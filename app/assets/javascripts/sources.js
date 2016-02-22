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

    $('.js-add_fieldset').on('click', function(event) {
        var $fieldset = $('.js-source_fieldset:first').clone();
        $('input, select', $fieldset).val('');
        $(this).parent().append($fieldset);
    });

    $('.js-fill_in_name').on('click', function(event) {
        var regex = $(this).siblings('.js-regex').val().split(' ');

        for(var i = 0; i < regex.length; i++) {
            regex[i] = regex[i][0].toUpperCase() + regex[i].substr(1).toLowerCase();
        }

        regex = regex.join(' ');

        $(this).siblings('.js-name').val(regex);
    });
});