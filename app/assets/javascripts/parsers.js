$(function() {
    $('#js-search_order_1, #js-search_order_2').sortable({
        connectWith: ".js-search_connected_sortable"
    }).disableSelection();

    $('#js-expected_order_1, #js-expected_order_2').sortable({
        connectWith: ".js-expected_connected_sortable"
    }).disableSelection();
});