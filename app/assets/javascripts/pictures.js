$(document).ready(function(){
	// disable auto discover
	Dropzone.autoDiscover = false;
 
	// grap our upload form by its id
	$("#new-picture").dropzone({
		// restrict image size to a maximum 1MB
		maxFilesize: 3,
		// changed the passed param to one accepted by
		// our rails app
		paramName: "picture[image]",
		// show remove links on each image upload
		addRemoveLinks: true,
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