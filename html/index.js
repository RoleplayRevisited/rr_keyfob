$(() => {
  // On trunk click
  $(".btn-left").click(function() {
    $.post('https://rr_keyfob/trunk');
  });

  $(".btn-right").click(function() {
    $.post('https://rr_keyfob/startstop');
  });

  $(".btn-top").click(function() {
    $.post('https://rr_keyfob/unlock');
  });

  $(".btn-top").dblclick(function() {
    $.post('https://rr_keyfob/alarm');
  });

  $(".btn-circle").click(function() {
    $.post('https://rr_keyfob/lock');
  });

  $('.window').each(() => {
    const $this = $(this);
    $this.on("click", () => {
      const id = $(this).data("window-id")
      $.post('https://rr_keyfob/toggleWindow', JSON.stringify({window: id}))
    });
  });

  window.addEventListener('message', (event) => {
    if (event.data.type == "enableKeyFob") {
     $("#fob").show();
    } else if (event.data.type == "playSound") {
      const audioPlayer = new Audio(`./sounds/${event.data.file}.ogg`);
      audioPlayer.volume = event.data.volume;
      audioPlayer.play();
    }
  });

  document.onkeyup = (data) => {
    if (data.key == 'Escape') {
      $.post('https://rr_keyfob/escape');
      $("#fob").hide();
    }
  };
});
