$(document).on('turbo:load', function() {
    $('.thumbnail').off('click');
    $('.thumbnail').on('click', function() {
      const PostID = $(this).data('post-id');
      $.ajax({
        url: '/histories/create', 
        type: 'POST',
        data: { post_id: PostID },
        dataType: 'json', 
        success: function() {
        },
        error: function() {
        }
      });
    });
  });