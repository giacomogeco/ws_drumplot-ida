

README Notes
- - -
Contents
* Note from me
* Zip file contents
* Installation
* Change notes
* Previous version information
* Acknowledgements

- - -
Thanks for trying out the waveform suite for MATLAB.  It's been a while since I've updated the version available for download from MathWorks, and many small changes (mostly bug-fixes) have occurred.  Active development of the waveform suite is taking place within the GISMO (Geophysical Institute Matlab Objects) suite by Mike West, Glenn Thompson, Chris Bruton and others. The code for GISMOtools is hosted at http://code.google.com/p/gismotools/ and most recent changes will be found there.  Major, hopefully stable, releases of the Waveform Suite are then zipped up and posted to MathWorks.  The r338 of the Waveform Suite,  includes a hook into the IRIS-DMC database, so that seismic data can be imported directly from IRIS into your MATLAB program without requiring that it be download elsewhere and then reloaded.  Information about using MATLAB and the Waveform Suite with IRIS can be found at http://www.iris.edu/manuals/javawslibrary/matlab/

The latest changes have been done in MATLAB 2011b.  Older versions of MATLAB may or may not support the more recent changes.

I offer the waveform suite in "as is" condition, with no real promises... yada yada... I won't take responsibility for your use or misuse of this collection of software... yada yada... please see the license as stated on the MATLAB Waveform Suite download page.  Oh, and ALWAYS back up your data (independent of whether or not you use this product, it's just smart.)

The waveform Suite has been described in the Electronic Seismologist column of Seismological Research Letters:
Reyes, C. G. and West, M. E., 2011. "The Waveform Suite: A Robust Platform for Manipulating Waveforms in MATLAB", SRL 82 (1) 104-110. 

Also, feel free to send a note with comments and suggestions to me or to the Gismotools user group, hosted at http://groups.google.com/group/gismotools.  

Thank you,
Celso Reyes
February 2012

- - - - - - - - - - - - - - - - - - - - - - - - 
README Notes
ZIP file contents:

    * @datasource/ source directory for the datasource class
    * @filterobject/ source directory for the filterobject class
    * @scnlobject/ source directory for the scnlobject class
    * @spectralobject/ source directory for the spectralobject class
    * @waveform/ source directory for the waveform class
    * uispecgram.fig UI component of the spectrogram generation program
    * uispecgram.m example of an interactive spectrogram generation program

- - - - - - - - - - - - - - - - - - - - - - - - 
Installation

Unzip the files either into the MATLAB directory from which you work, or into another directory. The parent directory (the one that contains all the @whatever directories) must be on the MATLAB path.

Additional help, along with examples can be found online at

    * http://kiska.giseis.alaska.edu/Input/celso/matlabweb/waveform_suite/waveform_suite_example_index.html : several examples of the waveform suite in use http://kiska.giseis.alaska.edu/Input/celso/matlabweb/waveform_suite/waveform.html : the main waveform information page. Check the links on the left for information about the other features of waveform.
    * http://kiska.giseis.alaska.edu/Input/celso/matlabweb/waveform_suite/download.html : (this page)

	
To enable log spectral plotting, please download  uimagesc, by Frederic Moisy, available at: http://www.mathworks.com/matlabcentral/fileexchange/11368
Then, extract it to a location along the MATLAB path.


= = = = = = = = = = = = = = = = = = = = = = = = 
Notes about the current release
Details about all releases can be found at hosted at http://code.google.com/p/gismotools/

r338
Updated waveform documentation and improved the error handling for
load_irisdmcws

r337
This modification preserves the absolute time (rather than just relative time)
information of the data used when working with a logarithmic y-axis. (submitted
by T. Bartholomaus)

r331 - 336
initial modification for irisdmcws compatibility

r323
Revised handling of null segtypes. Bug fix.

r319
Corrected Spelling error

r306
Optimization improvements to load_antelope and getfilename

r283
Fixed issue with concatenating output waveforms from multiple databases
in load_antelope.

r282
Added datenum method to waveform

r278
Updated uaf_continuous datasource. Several minor tweaks

r277
restored tested version of resample

r268
Improved the ability of waveform to handle wildcards in scnlobjects when used
against Antelope databases

r263 
Fixed bug allowing NaNs to sneak through FILLGAPS

r262
fixing  issue 19  and  issue 20 , where waveform was unable to correctly load sac files that either had wildcards in the filename or had the correct station information, but still wouldn't load.

r258
Fixing  issue 17 , where an error would occur when creating a specgram for a single waveform.

r257
Fixed extract.m for 'time' and 'index&duration'; which all suffered from an off-by-one.  Requesting one second of data returned one_second + one_sample,consistently.  The fixed version of extract returns the datapoints prior to the chosen end, instead of prior-to-and-including the chosen end.

r253
FILTFILT modification to allow arbitrary size waveforms.

r242
Added property NSCL_STRING to scnlobject/get.m.

r241
fixed error with dealing out history.

r240
fixed  issue 13 , where a date boundary wasn't properly being crossed.   This was fixed by a series of statements that say (for example) if 60 minutes, then actually make it 1 hour 0 minutes.  etc.

r239
continued repairs on waveform's constructor wrt dates

r238
fixed error that occurs if string date is used

r235
Fixed  Issue 12 , where requests for times that span multiple datasourced
filenames would fail with an Index Exceeds Matrix Dimensions error.

==== LAST RELESE TO MATHWORKS ====
r234
fixed error when non-vector dates passed to waveform. 
added a legend function to waveform, which allows the creation of plot legends without having to use waveform/get each time.
added "builtin" resamplemethod and fixed getfilename issue
fixed problem with load_seisan (cell vs string)


previous releases
r228 (MATHWORKS release)
enabled uispecgram to reproduce log plots
spectralobject plotting methods updated alowing more colorbar flexibility and complex plotting ability
demean no longer turns off history
undid the nanstuff, 'cause it turned out to be specific to the statistics toolbox
fixed waveform isempty

r211
Fixed a bug in R207 (introduced ~r190) where attempting to read in a recently saved waveform (structure v1.1) will cause an error.  This was caused by the removal of the station and channel fields (which had been deprecated since the introduction of scnlobjects)
Moved HISTORY out of miscelleneous fields and into its own proper field within the waveform structure.  This should save some speed overhead.
Fixed sign(waveform), which was transposing the data column.

r207

Notice that the version # has changed to a release number. This has been prompted by changes with how the source code is version-controlled, and is a little less arbitrary than the 1.xx versions created before.

Improved:

    * speed & memory efficiency: the workings of several functions have been streamlined to reduce the amount of data juggling that occurs behind the scenes.
    * error handling: Several error messages have been improved, providing better explanations and/or suggestions on how to prevent the errors. Additional tests have been added to some functions further validating the data in order to prevent surprise (or less intelligible) errors.
    * NaN support: r191 Basic statistical functions (std, var, median, etc.) were rewritten to take advantage of MATLAB's existing NaN support (eg, nanstd, nanvar, nanmedian). Where NaN values cannot be handled eloquently, the error messages and warnings have been improved to provide better information about what is occurring
    * history: r200 Displaying a waveform now shows the number of items in the history, along with the latest modification date. Previously, it merely showed as an Nx2 cell
    * help text: the help text has been improved for several functions

Added:

    * cumtrapz integration: added ability to specify integration method for waveform/integrate. Previously, only cumsum integration was allowed, but now 'trapz' can be specified, which will use matlab's cumtrapz function.
    * log specgram plots: r192 added the ability to stretch the y-axis logarithmically for spectrograms. This has been added to spectralobject/specgram and spectralobject/specgram2, and depends upon the function uimagesc, created by Frederic Moisy, and available at the matlabcentral file exchange: File 11368
      usage: specgram.m(spectralobject,waveform,'yscale','log')
      Special Thanks to Jason Amundson for this one!

Upgraded:

    * Mathematical operators: r189 When an NxM waveform is added, subtracted, multiplied, or divided ( ./ , .* , - , + ) by an NxM numeric.
      Where N is numeric and W is a waveform of the same size (both may be N-dimensional), then W .* N will multiply them element-wise. likewise, W + N will add them element-wise.
      ie., for addition, if W is a 1x2 waveform, and N is a 1x2 double, then
      W .* N = [W(1).* N(1) W(2) .*N(2)]
      The same will hold true for the other basic operators 

Removed:

    * user manual has been removed from the suite. It had grown outdated, and by now is more misleading than useful. For details about how to use the functions, consult the inline help. Additional resources are the waveform suite website and the GISMO user group.
    * global variables: r200 the number of global variables used withinn waveform has been reduced. In doing so, functions waveform/private/mep2dep and waveform/private/dep2mep have been reinstated. (These functions have yoyo'd between .m files and global inline functions ever since the inception of waveform.) Other than freeing up global namespace, this should be invisible to the user.
    * waveform/lookupunits.m has been removed from the waveform suite. Its use is antelope specific, and really doesn't belong with the distribution. Instead its name has been changed and is now located in the GISMO suite download contributed_antelope/add_waveform_fields/db_lookupunits.m
    * spectralobject/spwelch.m has been deprecated. Its functionality merely duplicated pwelch, and (perhaps) should not ever have been included in releases of the waveform suite.

- - - - - - - - - - - - - - - - - - - - - - - - 
Previous Versions

v 1.12
includes major changes to how waveform handles SAC files. Several bugs regarding the loading and saving of SAC files were brought to my attention. In response, all the sac-related files within the @waveform/private directory have been modified. These modification should be mostly transparent to overlying programs with the exception of User Fields.

When waveform opens a sac file, it read the header into user-defined fields. Much information from these fields were incorporated into the waveform, such as period, start time, units, etc. The user fields were then left in the waveform, but were vestigial. When a waveform writes out to a sac file, it recalculates much of this information because all of it was subject to change by the user. Now, most of these "vestigial" fields have been removed from the waveform. Fields that are no longer in the user-defined field section include: B, E, DEPMIN, DEPMAX, DEMEN, NPTS, KSTNM, KCMPNM, KNETWK, DELTA, NVHDR, IDEP, and LEVEN. All of the values contained in these fields are accessible through pre-existing means.

Starting with the file marked as v 1.10, i have implemented a fundamental change in the way waveform works. The source of the data, which used to be deeply entwined with the waveform class has been pulled out and split into its own class, datasource. This means that the waveform constructor call no longer requires a different series of arguments depending on the source. Now, the overlying program does not need to know whether data is imported via SAC, winston, antelope, etc. Additionally, this change has allowed the easy importation of user-defined file types and the ability to intelligently navigate directory structures. It is still backwards compatible, but warnings will be generated that aid the user in updating code to the new paradigm.

Support for the importation of SEISAN files was added, too. However, the inherent directory structure used with SEISAN precludes the datasource's ability to navigate and find the appropriate files. They can still be imported, but the file names will have to be individually declared.

scnlobjects were introduced as a way to make waveform more seed compliant, and to provide a robust way of handling the locales associated with each waveform. Other than the initial creation of scnlobjects necessary for the creation or importation of waveforms, this change is relatively transparent. That is to say, you can still access stations and channels through waveform's set/get routines without having to deal with the scnlobject contained within each waveform.

- - - - - - - - - - - - - - - - - - - - - - - - 
Acknowledgements

In one form or another, the waveform suite has been around for roughly 5 years. I'd like to thank those that have helped me improve it throughout that time. I especially would like to recognize Jackie-Caplan Auerbach (for introducing me to MATLAB and inspiring this suite in the first place), Jason Amundson (a great debugger and source of additional functionality), Micheal Thorne (who's SAC routines I thoroughly cannibalized), Glenn Thompson and Silvio DeAngelis (as testers and for SEISAN help), my advisor Steve McNutt (who let me get away with working on this stuff when, perhaps I should have been concentrating on the wiggles themselves), and Michael West (For plenty of discreet encouragement and great conversations on waveform philosophy... and author of the correlation toolbox, which is based upon the waveform suite.

I'm sure I'm leaving out important people; and I reserve the right to add them as they pop to mind.

Waveform Suite
for MATLAB