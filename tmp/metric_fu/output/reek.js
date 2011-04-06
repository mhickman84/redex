              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Reek: code smells';
        g.data('ControlCouple', [1])
g.data('Duplication', [16])
g.data('IrresponsibleModule', [7])
g.data('LongMethod', [8])
g.data('LowCohesion', [6])
g.data('NestedIterators', [5])
g.data('UncommunicativeName', [2])

        g.labels = {"0":"3/28"};
        g.draw();
