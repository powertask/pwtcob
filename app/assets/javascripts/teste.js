$(function() {
    $( '#datepicker1' ).datepicker({
      	showOtherMonths: true,
		formatDate: "dd/mm/yyyy",
      	selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		closeText: "Fechar",
		currentText: "Hoje",
		showButtonPanel: true,
		minDate: new Date(1900, 1, 1)
    });
  });

$(function() {
    $( '#datepicker2' ).datepicker({
      	showOtherMonths: true,
		formatDate: "dd/mm/yyyy",
      	selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		closeText: "Fechar",
		currentText: "Hoje",
		showButtonPanel: true,
		minDate: new Date(1900, 1, 1)
    });
  });
