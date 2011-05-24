$(document).ready(function() {
    $('#sidebar a').click(function() {
        selectDictionary($(this));
        return false;
    });
    $('input#reset').click(function() {
        resetForm();
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
    var resultsCount = $('#preview-item-target').children().size();
    if (resultsCount > 0) {
        previewButton.parents('form').attr('method', 'post');
        previewButton.attr('value', 'Import');
    } else {
        previewButton.parents('form').attr('method', 'get');
        previewButton.attr('value', 'Preview');
    }
}

function resetForm() {
    $('#preview-item-target').html('');
    $('#preview-form input').not(':reset').each(function() {
        $(this).val('');
    });
    $('#preview-form input').trigger('blur');
    toggleForm();
}