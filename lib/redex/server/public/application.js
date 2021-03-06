$(document).ready(function() {
    inlineLabels();
    $('.button').button();

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
    var maxHeight = findMaxHeight($('#page-content, #sidebar, #page-content'));
    $('#content').width(contentWidth - sideBarWidth);
    $('#page-content, #sidebar, #page-content').height(maxHeight);
}

function findMaxHeight(collection) {
    var maxHeight = 0;
    collection.each(function() {
        if ($(this).height() > maxHeight) {
            maxHeight = $(this).height();
        }
    });
    return maxHeight;
}

function findTemplate(str) {
    return str.replace("-list", "-template");
}

function selectDictionary(item) {
    $.ajax({
        dataType: 'json',
        url: '/dictionaries/select/' + item.text(),
        type: 'POST',
        success: function() {
            $('#content h4').text(item.text());
            item.addClass('selected');
        }
    });
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

