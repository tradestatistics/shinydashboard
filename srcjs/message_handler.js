

Shiny.addCustomMessageHandler('streamBox', function(data) {
    $.each(data, function(key, val){
      // get element
      el = document.getElementById(key);

      // TODO: Error handling... what if el does not exist?

      // update value
      if (el.classList.contains("small-box")) {
        // for valueBox
        vb = el.getElementsByClassName("value-box-value")[0];
        vb.innerText = val;
        vb.classList.add("box-value-updated");
        setTimeout(function() {vb.classList.remove("box-value-updated")}, 1000);
      } else if (el.classList.contains("info-box")) {
        // for infoBox
        ib = el.getElementsByClassName("info-box-number")[0];
        ib.innerText = val;
        ib.classList.add("box-value-updated");
        setTimeout(function() {ib.classList.remove("box-value-updated");}, 1000);
      }
    });
  });
