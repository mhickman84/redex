$(document).ready(function() {
    inlineLabels();
    setPageLayout();
    $(window).resize(function() {
        setPageLayout();
    });
    
    $('#sidebar a').click(function() {
        var header = $("#content h4");
        var linkText = $(this).text();
        var navId = '#' + $(this).parents('ul').attr('id');
        var templateId = findTemplate(navId);
        var targetId = findTarget(navId);

        $.ajax({
            dataType: "json",
            url: $(this).attr('href'),
            jsonp: "$callback",
            success: function(dictItems) {
                $(targetId).empty();
                $(templateId).tmpl(dictItems).appendTo(targetId);
                header.text(linkText);
            }
        });
        return false;
    });

    $('#preview-form').submit(function() {
        var templateId = '#preview-item-template';
        var targetId = '#preview-item-target';
        $.ajax({
            dataType: 'json',
            data: $(this).serialize(),
            url: $(this).attr('action'),
            type: 'POST',
            jsonp: "$callback",
            success: function(prevItems) {
                $(targetId).empty();
                $(templateId).tmpl(prevItems).appendTo(targetId);
            }
        });
        return false;
    });
});

function findTarget(str) {
    return str.replace("-list", "-target");
}

function findTemplate(str) {
    return str.replace("-list", "-template");
}


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

