$(function () {
    $('.js-disable_after_submit').bind("ajax:success", function (event, data) {
        if (data.errors) {
        } else {
            $('input[type=submit]', this).attr('disabled', true);
        }
    });
});