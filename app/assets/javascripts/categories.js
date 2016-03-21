$(document).ready(function () {
    $('.js-multiSelect').multiSelect();

    $('.js-better-select li').on('click', function(event) {
        $(this).parent().siblings().append(this);
        $('input', this).attr('disabled', function(i, v) { return !v; })
    });
});

