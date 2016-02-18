// ready to type
$(document).ready(function() {
    // ready to type
    $('.js-new_purpose').focus();

    // toggle save and input on click edit
    $('.js-edit_purpose').on('click', function(event) {
        event.preventDefault();

        var id = $(this).attr('data-id');
        var selector = '.js-purpose_form_'+id;

        var value = !$('.js-input', selector).prop('disabled');
        $('.js-input', selector).prop('disabled', value);

        $('.js-submit', selector).toggle();
    });
});


// on tab open another input field
$(document).on('keydown', '.js-new_purpose', function (e) {
    if (!e.shiftKey  && e.which == 9 && $(this).val().length > 0) {
        $(this).after(
            $(this).clone().val('').focus()
        );
        $(this).removeClass('js-new_purpose');
    }
});




$(document).on('ajax:error', '.js-purpose_form', function () {
    $(this).parent().effect('shake');
});

$(document).on('ajax:success', '.js-purpose_form', function (event, data) {
    if (data.errors && data.errors.length > 0) {
        $(this).trigger('ajax:error');
    } else {
        // toggle buttons
        $('.js-edit_purpose_form_'+data.purpose.id).click();

        // highlight
        $(this).parent().effect('highlight');
    }
});