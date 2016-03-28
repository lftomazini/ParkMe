(function(window, undefined) {
  var dictionary = {
    "a4f4be95-696d-415f-8104-900406eeac1f": "Alert_location",
    "d12245cc-1680-458d-89dd-4f0d7fb22724": "Map",
    "b5fbd82c-b86b-4696-9bd6-2374d86b15d7": "Alert_notifications",
    "51f036de-a31e-44da-82a2-3835013886da": "Map_results",
    "58b02944-7e91-432b-8303-1170efa51f9e": "Zone",
    "eaaab8bf-e2d0-4f06-a5d3-6f014a0ae206": "Search_results",
    "20a111cd-aaed-4c04-8755-c1c16e71068e": "Home",
    "5b15f10f-d751-4b05-9ba0-38ba9c67abb2": "Lock",
    "f39803f7-df02-4169-93eb-7547fb8c961a": "Template 1",
    "bb8abf58-f55e-472d-af05-a7d1bb0cc014": "default"
  };

  var uriRE = /^(\/#)?(screens|templates|masters|scenarios)\/(.*)(\.html)?/;
  window.lookUpURL = function(fragment) {
    var matches = uriRE.exec(fragment || "") || [],
        folder = matches[2] || "",
        canvas = matches[3] || "",
        name, url;
    if(dictionary.hasOwnProperty(canvas)) { /* search by name */
      url = folder + "/" + canvas;
    }
    return url;
  };

  window.lookUpName = function(fragment) {
    var matches = uriRE.exec(fragment || "") || [],
        folder = matches[2] || "",
        canvas = matches[3] || "",
        name, canvasName;
    if(dictionary.hasOwnProperty(canvas)) { /* search by name */
      canvasName = dictionary[canvas];
    }
    return canvasName;
  };
})(window);