$(document).ready(function() {
    $('.js-toggle_menu').on('click', function(event) {
        event.preventDefault();
        $('.js-nav').slideToggle();
    });
});