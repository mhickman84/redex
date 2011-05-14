$(document).ready(function() {
	inlineLabels();
});

function inlineLabels() {
    $('.field-container').each(function(index) {
        var lbl = $(this).children('label');
        var field = $(this).children('input:text');
        var fieldPadding = field.css('padding-left');
        var fieldBorder = field.css('border-width');
        var fieldMargin = field.css('margin-left');

        lbl.css('color', 'gray');

        if ($.trim(field.val()) == '') {
            lbl.position({
                my: "left top",
                at: "left top",
                of: field,
                offset: fieldPadding + fieldBorder + fieldMargin
            });
        }

        field.focus(function() {
            if ($.trim(field.val()) == '') {
                lbl.position({
                    my: "left bottom",
                    at: "left top",
                    of: field,
                    offset: fieldPadding + fieldBorder + fieldMargin
                });
            }
        });

        field.blur(function() {
            if ($.trim(field.val()) == '') {
                lbl.position({
                    my: "left top",
                    at: "left top",
                    of: field,
                    offset: fieldPadding + fieldBorder + fieldMargin
                });
            }
        });
    });
}

