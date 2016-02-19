$(document).ready(function () {
    $('.js-sources_table input, .js-sources_table select').change(function () {
        $(this).addClass('js-modified');
    });

    $('.js-update_many_sources_form').submit(function (e) {
        e.preventDefault();
        // jquery clone doesn't keep select or textarea values
        $(this).append($('.js-modified').remove().hide());
        this.submit();
    });
});