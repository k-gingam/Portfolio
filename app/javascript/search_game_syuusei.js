console.log("success");
var btn = document.getElementById('search_btn');
btn.addEventListener('click', function() {
  event.preventDefault();

  $.ajax({
        url: '/posts/search_game', 
        type: 'POST',
        data: $('form').serialize(),
        dataType: 'json', 
        success: function(response) {
          $('.js-search_result div').remove();

          if(response != ""){
          $(response).each(function(i,message) {
            let japaneseCoverUrl;
          if (message["cover"]) {
            japaneseCoverUrl = `https://images.igdb.com/igdb/image/upload/t_cover_big/${message["cover"]["image_id"]}.jpg`;
          } else {
            japaneseCoverUrl = "No_Image.png";
          }

            $('.js-search_result').append(
              
              `<div class="card" data-bs-dismiss="modal">
                <div class="row g-0">
                  <div class="col-md-2">
                    <img class="game_icon" src="${japaneseCoverUrl}" width="80px" height="80px" >
                  </div>
                  <div class="col-md-8">
                    <li class="game_name py-2 px-4" style="list-style: none;">${message["name"]}</li>
                  </div>
                </div>
              </div>`
            );
          });

          $('.js-search_result').on('click', '.card', function() {
            const SelectGameName = $(this).find('.game_name').text();
            const SelectGameIcon = $(this).find('.game_icon').attr('src');
            $('#game_name').val(SelectGameName);
            $('#game_icon').val(SelectGameIcon);
          });
          } else {
            $('.js-search_result div').remove();
            $('.js-search_result').append(
            `<div>ゲームが見つかりませんでした。</div>`
            );
          }
        },
        error: function() {
        }
    });
  })

  