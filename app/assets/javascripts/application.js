//= require modernizr
//= require jquery
//= require jquery_ujs
//= require moment
//= require fullcalendar
//= require_tree .


function showEventDetails(event){
    jQuery.ajax({
        data: 'id=' + event.id,
        dataType: 'script',
        type: 'get',
        url: '/tasks/get_click'
    });
};
