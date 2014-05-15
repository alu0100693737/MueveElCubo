"use strict"; // Use ECMAScript 5 strict mode in browsers that support it

$(document).ready(function() {
var dropZone = document.getElementById('drop_zone');
dropZone.addEventListener('dragover', handleDragOver, false);
dropZone.addEventListener('drop', handleFileSelect, false);
});
  
  function handleFileSelect(evt) {
    evt.stopPropagation();
    evt.preventDefault();

    var files = evt.dataTransfer.files; // FileList object.

    // files is a FileList of File objects. List some properties.
    var output = [];
    for (var i = 0, f; f = files[i]; i++) {
      output.push('<li><strong>', escape(f.name), '</strong> (', f.type || 'n/a', ') - ',
                  f.size, ' bytes, last modified: ',
                  f.lastModifiedDate ? f.lastModifiedDate.toLocaleDateString() : 'n/a',
                  '</li>');
    }
    document.getElementById('list').innerHTML = '<ul>' + output.join('') + '</ul>';
  }

  function handleDragOver(evt) {
    evt.stopPropagation();
    evt.preventDefault();
    evt.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
  }
  
  
  
  //PONER EN EL JS CORRESPONDIENTE
  
  "use strict";

$(document).ready(function() {
   if (window.localStorage && localStorage.initialinput && localStorage.finaloutput)
   {
    out.className = 'unhidden';
    initialinput.innerHTML = localStorage.initialinput;
    finaloutput.innerHTML = localStorage.finaloutput;
   }
   
   
   var dropZone = document.getElementById('fileinput');
   dropZone.addEventListener('dragover', handleDragOver, false);
   dropZone.addEventListener('drop', handleFileSelect, false);
   $("#fileinput").change(FUNCION JS CORRESPONDIENTE) //funcion correspondiente
     
  );
});