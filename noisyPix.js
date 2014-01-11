$(function(){
	
	var oMessage 		= $('#message');
	var oPhotoHolder	= $('#photoHolder');
	
	$('#dropbox').filedrop({
		paramname:'uploadFile',
		maxfiles: 10,
    	maxfilesize: 5, // max file size in MBs
		url: 'post.cfm',
		
		data: {
			strMyId: mySession.strMyId
		},
		
    	error: function(err, file) {
			switch(err) {
				case 'FileTooLarge':
					showMessage(file.name + ' is <strong>too large!</strong> Please upload files up to ' + maxfilesize + 'mb.');
					break;
				case 'BrowserNotSupported':
					showMessage('Your browser does not support HTML5 file uploads!');
					break;
				case 'TooManyFiles':
					showMessage('Too many files! Please select ' + "5" + ' at most!');
					break;
				default:
					break;
			}
		},
		
		beforeEach: function(file){
			// Before each upload starts
			if(!file.type.match(/^image\//)){
				showMessage('That was not an image');
				// fail
				return false;
			}
			$('#errorBox').hide();
		},
		
		uploadFinished: function(i, file, response, time) {
			// Use the JSON response from server to check for server side errors
			if( (typeof(response.BERROR) == 'undefined') || (response.BERROR == true)){
				showMessage(file.name + ' ' + response.STRMSG);
				
				var strIdName		= file.name.slice(0,file.name.length - 4);
				
				//unfortunately, if someone uploads the same file twice, we'll have two divs with the same ID.
				$('#photoHolder').find('#' + strIdName + ' > .imgDone').each(function(){
					objDone	=	$(this);
					
					//now get the img tag inside the parent (thumbNail).
					objImg	=	objDone.parent().find("img");
					
					objDone.removeClass('imgDone');
					objDone.addClass('imgError');
					
					//set the span to have the same heigh and width as the img...and show.
					objDone.css('height',objImg.height());
					objDone.css('width',objImg.width());
					objDone.show();
				});
				
			}else{
				//get each HIDDEN 'imgDone span' which is a child of .thumbNail and (in turn) a child of #photoHolder
				$('#photoHolder').find(".thumbNail :hidden").each(function(){
					//so this actually = the span inside .thumbnail
					objDone	=	$(this);
					
					//now get the img tag inside the parent (thumbNail).
					objImg	=	objDone.parent().find("img");
					
					//set the span to have the same heigh and width as the img...and show.
					objDone.css('height',objImg.height());
					objDone.css('width',objImg.width());
					objDone.show();
				});
				
				//Show the Download box
				if ($('#downloadBox').css('display') == 'none') {
					$('#downloadBox').show();
				}

			}
		},
		
		uploadStarted:function(i, file, len){
			//create thumbnail
			createThumbnail(file);
		}
    	 
	});
	
	function createThumbnail(file){
		//create a thumbnail container with img inside
		var strIdName		= file.name.slice(0,file.name.length - 4);
		var strThumbNail	= '<div id="' + strIdName + '" class="thumbNail"><span class="imgDone"></span><img /></div>';
		var oThumbNail		= $(strThumbNail);
		var oImage			= $('img', oThumbNail);
		var oReader			= new FileReader();
		
		oReader.onload = function(e){
			//onLoad set img src
			oImage.attr('src',e.target.result);
		};
		
		oReader.readAsDataURL(file);
		
		//move the message box up top and make it smaller
		oMessage.removeClass('message_big');
		oMessage.addClass('message_small');
		oPhotoHolder.show();
		
		//restrict size of thumbnail
		oImage.css('max-height','120px');
		oImage.css('max-width','180px');
		
		//stick thumbnail into photoHolder span
		oThumbNail.appendTo(oPhotoHolder);
	}
	

	function showMessage(msg){
		$('#errorBox').show();
		$('#errorText').html(msg);
	}

});
