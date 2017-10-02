# HyperAQ

This is the Hyperloop version of the Aquarius sprinkler server, deployed on a RasberryPI 3.

Theory of Operation

  This is an implementation of a standard Ruby-on-Rails app, with a Hyperloop UI.  This rails server was designed to function as a headless server, starting and stopping lawn sprinkler valves, following a pre-planned sequence.  As such, the server does not expect to receive operational instructions from the UI, so the UI role is mostly to wait for scheduled activity, be notified of state changes via hyperloop channels from the server, and keep the UI updated.  As part of this role, the UI uses some simple color-coding, along with table sorting, to indicate server activity.

  There is some manual intervention required: it is necessary for an operator to select Active mode after the server has been started, and an operator can control the valves manually at all times.

Models

  * Valve

    This is the fundamental object of this app.  There are 5 valves under management.  Each valve has 3 key attributes: name, command_state, and GPIO pin number.  A valve can be controlled by schedule, simply create some sprinkles that specify valve on/off times.  A valve also can be controlled manually, by pushing one of the valve buttons on the nav bar.  In both cases, a dependent History object is created to log the on/off times.

  * Sprinkle

    A Sprinkle is a calendar object; it identifies a valve, a 'time input' field, such as 'Tue 9:48 am', and a duration field in minutes.  Sprinkles are mapped into the system crontab, with a crontab entry for each Sprinkle-on and Sprinkle-off.  Sprinkles are weekly objects, so a daily valve sprinkle cycle would be made up of 7 Sprinkle records.

  * History (List)

    Histories are simple logging objects.  Each History is owned by a Valve, and has two time states: start and stop.  When a Valve goes on, a History object is created with a start time set.  When that Valve goes off, the history object is updated with a stop time and saved for display purposes. BTW: The model name was changed to 'List', to avoid an Opal inflection bug, which produced "Historie", as the singular of "Histories".

  * WaterManager

    WaterManager is a singleton, and acts as the manager of the sprinkling schedule.  When the 'Standby' button on the nav bar is pushed, the WaterManager requests the WaterManagerServer, a ServerOp, to build a new crontab from the sprinkles and activate the system for scheduled sprinkling. Conversely, pushing the button marked Active will cause a transition to Standby mode, disabling all scheduled operations.

  * Porter

    Porter is a bit peculiar.  The reason for Porter goes to the use of crontab as the source of sprinkle scheduling requests.  A crontab request must be posted against a controller, using an http request, in this case a PUT request.  In order to make this request, the caller must know the complete URL of the server, including the port number in use.  In a rails app, the ONLY known way to access the port number is to reference 'request.port', within the context of a controller processing a request.  Since Hyperloop does not use the rails controllers to access and update the rails models, we have a problem.  So, it was necessary to synthesize a request from within the hyperloop browser image, catch that request in a controller, and extract the port key necessary for other crontab operations.  Porter was created to simply stash the port number of the server, and the hostname of the server host.  It is called Porter because I am a fan of British TV mysteries, many of which are set at Oxford University, where 'porters' are the 'keepers of the keys' of the various Oxford colleges.  

    To get a Porter computed, you make an http(json) get request against the '/porter/1' address, and that request is made in the 'after_mount' method of the PorterStatus component.  The 'show' method of the PortersController does all the dirty work and updates the Porter.first AR record with the right stuff.

Components

  * App
  This is the parent Component, it is referenced by config/routes.rb to get the hyperloop image created.

    * Navbar

      Navbar is based on Bootstrap, as is all of the markup in the app.  The navbar contains 4 sections, defined below.

      * PorterStatus

        PorterStatus reports the server host and port values.  This data is used by the crontab entries that drive the sprinkles.  It is displayed here as a debugging aid to distinguish a production Raspberry PI host versus an Ubuntu development machine.

      * WaterStatus

        This is the main manual control. Pressing it to Active will activate the sprinkle scheduling, allowing scheduled sprinkles to proceed.  In Standby mode, no sprinkle scheduling occurs.

      * TitleNav

        TitleNav is just a bit of advertising about this system.

      * ValveButtons

        This is a collection of buttons representing the valves used in the installed system.  Since there are only 5 valves used in this installation, they are mapped to 5 buttons on the right side of the navbar.  

        Valves can be controlled either manually or by scheduled sprinkle.  When one of these occurs, the matching valve shows that it is on, and then turns off at the end of the sprinkle.  When a valve is on by schedule and is then pushed manually, the manual intervention will cause the valve to close and the open History to be completed.  If a valve is on when a scheduled 'on' event occurs, the valve will stay on.  When the scheduled valve close happens, the valve will be closed, no matter how it was opened.

      * ValveButton

        A ValveButton is a reactive-element, which means that it will change color and become active if a scheduled sprinkle turns on the valve, but it will also work in manual mode, where a user can open and close any or all of the valves by pushing the buttons.

    * Layout

      This component creates the structure required to display the two major lists of this application.

      * SprinkleList

        SprinkleList is intended to display a complete list of scheduled sprinkles.  They are to be sorted so that the next sprinkle to become active is always at the top of the table. When a sprinkle sequence completes, the next_start_time field is updated by a week, and the table is sorted so that it goes to the bottom of the list.

        * SprinkleRow

        At any point in time, there is only one Sprinkle marked Next(rose color).  That is when no sprinkle is in action, and the system is quiet.  The next sprinkle scheduled has the Next state.
        When a sprinkle gets activated, its' state becomes Active(blue).  All other sprinkles are marked Idle(plain).  When an active sprinkle stops sprinkling, its' state goes to Idle, and its next_start_time attribute is updated to its next scheduled on/off sequence, and it is sorted to the end of the list.

      * HistoryList

        History entries are created by valve activity. When a valve turns on, it creates a new History, with a start_time displayed, but no stop time.  When the valve is closed, the matching History entry is updated to record the stop time.  Histories are sorted as a push-down stack, so that the latest History is always at the top.

        * HistoryRow

        When a History is active, it's background is marked pale yellow.  When it is idle, its background is plain.

Operations

  * WaterManagerServer

    This operation is a ServerOp, which means that it gets invoked from the UI, by means of a Standby/Active push button on the navbar.
    When the button is pushed from Standby, this agent will cause a new crontab file to be built from the existing list of Sprinkles, with an entry at the scheduled turn-on time, and again at the scheduled turn-off time (start_time + duration).  The WaterManager state is set to Active, and the button changes color to orange.  For each Sprinkle on/off sequence, a History (List) record is created to record the activity.

    In order to stop all scheduled sprinkles, push the Active button and watch it go to Standby.  Manual valve operations are still available.

  * ManualValveServer

    This operation is a ServerOp, invoked from any of the 5 Valve buttons. The valve will change state and the button color will change accordingly.  As in the scheduled case, a History is created to record activity.

Setup

  * To get the app installed and running, do the following:

    * edit the config/database.yml file to replace my working credentials with yours. Mysql is used, so the mysql server must be installed prior to use.

    * execute the shell command 'dev-run.sh', which will clear all log files, run bundle update, drop the database and rebuild it, including seeds.rb, and finally launch puma in development mode.  

    * you can then press the Standby button and activate the sprinkles in the database, which will start to execute on their appointed schedule (the seeds.rb file contains code that will build a database of 10 sprinkles, starting 2 minutes after seeds.rb is run.  This is to provide a convenient set of time-dependent sprinkles. Once all run, then take down the server and run the script again to get a new sprinkle set.) You should be able to see the valve buttons light up to track scheduled sprinkles at work, and the state color of the sprinkle table will cycle between Idle, Next, and Active, while the next_start_time field will update to the next schedule.

    * The valve buttons also work in manual mode; when you push a valve button, the valve turns on and a history record is added with the start time recorded.  Press it again, and the stop time will be added to the history record.

    * Most of the more complex bits of code have a log file associated with them.  When in use, these files are opened in the log folder.  You can open the file in an editor and uncomment the log function and the various log statements in the file to watch actions take place, recording them for posterity.  See app/hyperloop/operations/water_manager_server.rb as an example.


