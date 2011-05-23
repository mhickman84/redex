$(document).ready(function() {
    inlineLabels();
    $('input:submit').button();

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
                $("#content").position({
                    my: "left top",
                    at: "right top",
                    of: "#sidebar"
                });
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
                setPageLayout();
            }
        });
        return false;
    });

    setPageLayout();
    $(window).resize(function() {
        setPageLayout();
    });
});

function findTarget(str) {
    return str.replace("-list", "-target");
}

function setPageLayout() {
    var contentWidth = $('#page-content').outerWidth();
    var sideBarWidth = $('#sidebar').outerWidth();
    $('#content').width(contentWidth - sideBarWidth);
    $('#sidebar').height($('#content').height());
}

function findTemplate(str) {
    return str.replace("-list", "-template");
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

