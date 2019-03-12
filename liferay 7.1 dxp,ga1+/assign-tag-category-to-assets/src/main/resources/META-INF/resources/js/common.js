// Open Dialog
function openTagCategorySelectDialog(iconId,form,assetType,idSelectorExcept,renderJSPURL,namespace) {
	// Assign Tag and Category Open Dialog Box
	var assetIds = Liferay.Util.listCheckedExcept(form, '<portlet:namespace />'+idSelectorExcept);	
	openDialog(assetIds,assetType,renderJSPURL,namespace);
}

// Dialog Box 
function openDialog(assetIds,assetType,renderJSPURL,namespace) {
		
	AUI().use( 'aui-io','aui-dialog',
	function(A) {
		Liferay.Util.openWindow({
		dialog: {
			centered: true,
		    destroyOnClose: true,
		    cache: false,
		    width: 850,
		   	height: 500,
		    modal: true,
		},
		title: 'Assign Metadata Information',
		id:'metadataDialog',             
		uri: ""+renderJSPURL+"&"+namespace+"assetIds="+assetIds+"&"+namespace+"assetType="+assetType
	});
 });  
}

// Show Notification message 
function showNotificationMsg(msgDivId,alertType,alertMsg){
	$(msgDivId).empty();
	$(msgDivId).append("<div class=\"alert alert-"+alertType+"\">"+alertMsg+"</div>");
}



