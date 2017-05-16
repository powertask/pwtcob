//= require modernizr
//= require jquery3
//= require jquery_ujs
//= require jquery-ui
//= require tether
//= require moment
//= require_tree .
//= require jquery.turbolinks

function showEventDetails(event){
    jQuery.ajax({
        data: 'id=' + event.id,
        dataType: 'script',
        type: 'get',
        url: '/home/get_click'
    });
};
