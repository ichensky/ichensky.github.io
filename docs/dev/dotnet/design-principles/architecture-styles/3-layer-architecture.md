# 3 Layer Architecture

A three-layer architecture is a common software design pattern that divides an application into three distinct layers.<br>
A layer is a logically separated part of the application.

`Presentation Layer` - Handles user clicks, HTTP requests, and provides the API for user interaction. 

`Domain Layer` - Domain(business) logic of the application. This layer handles data and converts it to other data structures.

`Data Access Layer` - Provides access to the database and manages transactions.


<hidden style="display:none">
@startuml
component "Presentation Layer" {
}
component "Domain Layer" {
}
component "Data Access Layer" {
}

"Presentation Layer" --> "Domain Layer"
"Domain Layer" --> "Data Access Layer"

@enduml
</hidden>


<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentStyleType="text/css" data-diagram-type="CLASS" height="271px" preserveAspectRatio="none" style="width:184px;height:271px;background:#FFFFFF;" version="1.1" viewBox="0 0 184 271" width="184px" zoomAndPan="magnify"><defs/><g><!--entity Presentation Layer--><g id="elem_Presentation Layer"><rect fill="#F1F1F1" height="46.2969" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="171.9609" x="7" y="7"/><rect fill="#F1F1F1" height="10" style="stroke:#181818;stroke-width:0.5;" width="15" x="158.9609" y="12"/><rect fill="#F1F1F1" height="2" style="stroke:#181818;stroke-width:0.5;" width="4" x="156.9609" y="14"/><rect fill="#F1F1F1" height="2" style="stroke:#181818;stroke-width:0.5;" width="4" x="156.9609" y="18"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="131.9609" x="22" y="39.9951">Presentation Layer</text></g><!--entity Domain Layer--><g id="elem_Domain Layer"><rect fill="#F1F1F1" height="46.2969" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="137.8086" x="24.08" y="113.3"/><rect fill="#F1F1F1" height="10" style="stroke:#181818;stroke-width:0.5;" width="15" x="141.8886" y="118.3"/><rect fill="#F1F1F1" height="2" style="stroke:#181818;stroke-width:0.5;" width="4" x="139.8886" y="120.3"/><rect fill="#F1F1F1" height="2" style="stroke:#181818;stroke-width:0.5;" width="4" x="139.8886" y="124.3"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="97.8086" x="39.08" y="146.2951">Domain Layer</text></g><!--entity Data Access Layer--><g id="elem_Data Access Layer"><rect fill="#F1F1F1" height="46.2969" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="169.5342" x="8.21" y="219.59"/><rect fill="#F1F1F1" height="10" style="stroke:#181818;stroke-width:0.5;" width="15" x="157.7442" y="224.59"/><rect fill="#F1F1F1" height="2" style="stroke:#181818;stroke-width:0.5;" width="4" x="155.7442" y="226.59"/><rect fill="#F1F1F1" height="2" style="stroke:#181818;stroke-width:0.5;" width="4" x="155.7442" y="230.59"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="129.5342" x="23.21" y="252.5851">Data Access Layer</text></g><!--link Presentation Layer to Domain Layer--><g id="link_Presentation Layer_Domain Layer"><path codeLine="8" d="M92.98,53.78 C92.98,71.27 92.98,89.38 92.98,106.86 " fill="none" id="Presentation Layer-to-Domain Layer" style="stroke:#181818;stroke-width:1;"/><polygon fill="#181818" points="92.98,112.86,96.98,103.86,92.98,107.86,88.98,103.86,92.98,112.86" style="stroke:#181818;stroke-width:1;"/></g><!--link Domain Layer to Data Access Layer--><g id="link_Domain Layer_Data Access Layer"><path codeLine="9" d="M92.98,160.08 C92.98,177.57 92.98,195.67 92.98,213.15 " fill="none" id="Domain Layer-to-Data Access Layer" style="stroke:#181818;stroke-width:1;"/><polygon fill="#181818" points="92.98,219.15,96.98,210.15,92.98,214.15,88.98,210.15,92.98,219.15" style="stroke:#181818;stroke-width:1;"/></g><!--SRC=[IyxFBSZFIyqhKL0AA4ej1Z8IIpBpynHy4YjJYvGKghbgkP8HIbpoSnCpSKecbYGgE2OdfnON8wlWmcgmhguTcd5SQAP3L62O2G00]--></g></svg>

### Note
`Presentation Layer` can initiate calls to code from `Domain Layer`, not vice versa.
`Domain Layer` can initiate calls to code from `Data Access Layer`, not vice versa.