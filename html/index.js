$("#fob").hide();

$(function() {
  // On trunk click
  $(".btn-left").click(function() {
    $.post('https://rr_keyfob/trunk', JSON.stringify({}));
  });

  $(".btn-right").click(function() {
    $.post('https://rr_keyfob/startstop', JSON.stringify({}));
  });

  $(".btn-top").click(function() {
    $.post('https://rr_keyfob/unlock', JSON.stringify({}));
  });

  $(".btn-top").dblclick(function() {
    $.post('https://rr_keyfob/alarm', JSON.stringify({}));
  });

  $(".btn-circle").click(function() {
    $.post('https://rr_keyfob/lock', JSON.stringify({}));
  });

  $('.window').each(function() {
    let $this = $(this);
    $this.on("click", function() {
      const id = $(this).data("window-id")
      $.post('https://rr_keyfob/toggleWindow', JSON.stringify({window: id}))
    });
  });

  window.addEventListener('message', function(event) {
    if (event.data.type == "enableKeyFob") {
     $("#fob").show();
    } else if (event.data.type == "playSound") {
      let audioPlayer = new Audio('./sounds/' + event.data.file + ".ogg");
      audioPlayer.volume = event.data.volume; 
      audioPlayer.play();
    }
  });

  document.onkeyup = function (data) {
    if (data.which == 27) { // Escape key
        $.post('https://rr_keyfob/escape', JSON.stringify({}));
        $("#fob").hide();
    }
};
});