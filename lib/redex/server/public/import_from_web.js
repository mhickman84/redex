$(document).ready(function() {
    $('#sidebar a').click(function() {
        selectDictionary($(this));
        return false;
    });
    $('#preview-form').submit(function() {
        var templateId = '#preview-item-template';
        var targetId = '#preview-item-target';
        $.ajax({
            dataType: 'json',
            data: $(this).serialize(),
            url: $(this).attr('action'),
            type: $(this).attr('method'),
            jsonp: "$callback",
            success: function(prevItems) {
                $(targetId).empty();
                $(templateId).tmpl(prevItems).appendTo(targetId);
                setPageLayout();

                toggleForm();
            }
        });
        return false;
    });
});

function toggleForm() {
    var previewButton = $('input#preview');
    if ($('#preview-item-target').children().size() > 0) {
        previewButton.parents('form').attr('method', 'post');
        previewButton.attr('value','Import');
    } else {
        previewButton.parents('form').attr('method', 'get');
        previewButton.attr('value','Preview');
    }
}