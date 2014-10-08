# Description #
GDataXML-HTML is a HTML/XML parser for iOS and OSX, based on Google's GDataXML. As the name suggest it adds support for the HTMLparser module of libxml2 and enables you to deal with non validating XML or HTML. 
So you can use e.g. XPath to parse Websites with reasonable performance

# Use in your own project #
### Assuming XCode 4 but should work in XCode 3 ###

1. First add the files from the lib/ folder in this project to your source tree, then include them somewhere in your code,

2. In Xcode4 choose the project file (in the project navigator, the top item).

3. In the list choose your project target and select 'Build Settings' at the top of the window.
Then you should see a list of build options.

4. Add this line to 'Header Search Paths' (use search bar to find the right option)
/usr/include/libxml2

5. Add this line to 'Other Linker Flags':
-lxml2

## ARC ##
GDataXML-HTML is build with ARC support

# Examples #
There are usage examples inside the GDataXML_HTMLViewController.m file.

### Other examples for GDataXML on the web: ###

1. http://www.raywenderlich.com/725/how-to-read-and-write-xml-documents-with-gdataxml

2. http://dubydigital.com/iphone/?p=59

# Licence #
Original GDataXML:
Copyright (c) 2008 Google Inc

Example project and HTML addons:
Copyright (c) 2012 Simon Grätzer

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.