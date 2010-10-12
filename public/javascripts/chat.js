function simplechat(options){
     var user_uid = options["user_uid"];
     var send_fn = options["send"];
     var listen_fn = options["listen"];
     $("#chatbox_"+user_uid).remove();

     this.show_message = function(message){
             var content_chatbox = $("#chatbox_"+user_uid);
             var content_msg = $(content_chatbox).find("div.chatboxcontent");
           $(content_msg).append("<div class='chatboxmessage'><span class='chatboxmessagefrom'>"+options["title"]+": </span><span class='chatboxmessagecontent'>"+message+"</span></div>");
     };

     var chatbox = "<div id='chatbox_"+user_uid+"' class='chatbox'style='bottom: 0px; right: 20px; display: block;'><div class='chatboxhead'><div class='chatboxtitle'>"+options["title"]+"</div><div class='chatboxoptions'><a href='#' class='min-max-chat'>-</a></div><br clear='all'></div><div class='chatboxcontent' style='display: none;'></div><div class='chatboxinput' style='display: none;'><textarea class='chatboxtextarea'></textarea></div></div>";
     $(chatbox).appendTo('body');
     var input_field = $("#chatbox_"+user_uid).find("textarea.chatboxtextarea:first");
     $(input_field).live("keypress", function(event){
         if (event.keyCode == '13' && event.shiftKey == 0) {
           var msg = $(this).val();
           $(this).val("");
           var content_chatbox = $(this).parents("div.chatbox:first");
           var content_msg = $(content_chatbox).find("div.chatboxcontent");
            $(content_msg).append("<div class='chatboxmessage'><span class='chatboxmessagefrom'>me :</span><span class='chatboxmessagecontent'>"+msg+"</span></div>");
           send_fn({"user_uid": user_uid, "message": msg});
          } ;

     });
    listen_fn(this);
};
$(function(){
      $("a.min-max-chat").live('click', function(){
         var content_chatbox = $(this).parents("div.chatbox:first");
         var i = $(content_chatbox).find("div.chatboxinput");
         var h = $(content_chatbox).find("div.chatboxcontent");
         $(i).toggle(); $(h).toggle();
      return false;
     })
});

