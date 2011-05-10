function loadPage(name) {
    var pageContainer = $('#page-content');
    pageContainer.empty();
    $.getJSON('/pages/' + name, function(data) {
        var templateUrl = 'views/pages/' + name + '.html';
        $.get(templateUrl, function(template) {
            $.tmpl(template, data).appendTo(pageContainer);
        });
    });
}

