$(document).ready(function(){
	// disable auto discover
	Dropzone.autoDiscover = false;
 
	// grap our upload form by its id
	$("#new-picture").dropzone({
		// restrict image size to a maximum 1MB
		maxFilesize: 1,
    maxThumbnailFilesize: 1,
    maxFiles: 3,
    acceptedFiles: 'image/*',
		// changed the passed param to one accepted by
		// our rails app
		paramName: "picture[image]",
		// show remove links on each image upload
		addRemoveLinks: true,
    dictCancelUpload: "Annuler",
    dictRemoveFile: "Supprimer",
    dictDefaultMessage: "Cliquez pour ajouter des photos ou insérez les directement dans cette zone.",
    dictFileTooBig: "Fichier trop lourd. 1Mb maximum par photo.",
    dictMaxFilesExceeded: "Vous avez droit d'ajouter 3 images maximum par annonces.",
    // Preload images
    init: function() {
      var data = $('#picture_advert').attr("data_present");
      var advert_id = $('#picture_advert').attr("advert_id");
      var thisDropzone = this;
      if (data == "1") {
        $.ajax({
          type: 'GET',
          url: '/adverts/' + advert_id + '/preload_pictures',
  				success: function(data){
            $.each(data, function(key,value) {
              var mockFile = { name: value.name, size: value.size };
              thisDropzone.emit("addedfile", mockFile);
              thisDropzone.emit("thumbnail", mockFile, value.url);
              thisDropzone.emit("complete", mockFile);
              $(mockFile.previewTemplate).find('.dz-remove').attr('id', value.id);
              thisDropzone.files.push(mockFile);
              thisDropzone.options.maxFiles = thisDropzone.options.maxFiles - 1;
            });
  				}
        });
      }
    },
		// if the upload was successful
		success: function(file, response){
			// find the remove button link of the uploaded file and give it an id
			// based of the fileID response from the server
			$(file.previewTemplate).find('.dz-remove').attr('id', response.fileID);
			// add the dz-success class (the green tick sign)
			$(file.previewElement).addClass("dz-success");
		},
		//when the remove button is clicked
		removedfile: function(file){
			// grap the id of the uploaded file we set earlier
			var id = $(file.previewTemplate).find('.dz-remove').attr('id');
 
			// make a DELETE ajax request to delete the file
			$.ajax({
				type: 'DELETE',
				url: '/pictures/' + id,
				success: function(data){
					$(file.previewTemplate).hide();
					console.log(data.message);
				}
			});
		} 
	});
}); 