$(document).ready(function() {
	inlineLabels();
	setPageLayout();
	$(window).resize(function() {
		setPageLayout();
	});
});

function setPageLayout() {
	var contentHeight = $('#main-content').height();
	var contentWidth = $('#main-content').outerWidth(true);
	var sidebarWidth = $('#sidebar').outerWidth(true);
	$('#sidebar').height(contentHeight);
	$('#content h4').width(contentWidth - sidebarWidth - yPaddingAndMargins($('#content h4')));
}

function yPaddingAndMargins(element) {
	var left = parseInt(element.css('padding-left')) + parseInt(element.css('margin-left'));
	var right = parseInt(element.css('padding-right')) + parseInt(element.css('margin-right'));
	return left + right;
}

function inlineLabels() {
    $('.field-container').each(function(index) {
        var lbl = $(this).children('label');
        var field = $(this).children('input:text');

        lbl.css('color', 'gray');

        if ($.trim(field.val()) == '') {
            lbl.position({
                my: "left center",
                at: "left center",
                of: field,
                offset: '5 0'
            });
        }

        field.focus(function() {
            if ($.trim(field.val()) == '') {
                lbl.position({
                    my: "left bottom",
                    at: "left top",
                    of: field,
                    offset: '5 0'
                });
            }
        });

        field.blur(function() {
            if ($.trim(field.val()) == '') {
                lbl.position({
                    my: "left center",
                    at: "left center",
                    of: field,
                    offset: '5 0'
                });
            }
        });
    });
}

