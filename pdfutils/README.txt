/*-
 * Copyright (c) 2011 Evan F. Bollig
 * All rights reserved.
 *
 * This code is derived from software developed for 
 * National Science Foundation awards numbered  DMS-#0934331 (FSU), 
 * DMS-#0934317 (NCAR) and ATM-#0602100 (NCAR).
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY Evan F. Bollig AND OTHER CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

==============================
Todays Date: October 5th, 2011 
==============================
Version: v0.1
==============================

What is this?: 
==============
    auto-trim.sh is a bash script written for OSX to automatically crop images
    to the minimum bounding box. In many images, we find an excess of white
    space or background information, and we need to crop this out when
    embedding the images into a publication. This script simplifies the task. 


Usage: 
======
    # Run the script on any image format (outputs "trimmed_<FILE_NAME>.pdf")
    <PATH_TO_SCRIPT>/auto-trim.sh file.pdf

    # Check the output
    open trimed_file.pdf


Required Software (To Run): 
===========================
    OSX 10.6 (With Automator.app installed)
    ImageMagick "convert" command (NOTE: install ImageMagick via Homebrew, MacPorts, or Fink)


Supported Input Formats: 
========================
    We use ImageMagick to convert images to PDF. Therefore, any image format
    supported by ImageMagick. The script has been verified to work on PNG, JPG,
    EPS, and PDF images. 
