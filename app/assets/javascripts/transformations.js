$(document).ready(function () {

    // for update form
    $('.js-transformations_table input').change(function () {
        $(this).addClass('js-modified');
    });

    $('.js-update_many_transformations_form').submit(function (e) {
        e.preventDefault();
        // jquery clone doesn't keep select or textarea values/
        // not that I need them here
        $(this).append($('.js-modified').remove().hide());
        this.submit();
    });
});