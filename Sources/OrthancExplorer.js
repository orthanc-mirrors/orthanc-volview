/**
 * SPDX-FileCopyrightText: 2023 Sebastien Jodogne, UCLouvain, Belgium
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

/**
 * Kitware's VolView plugin for Orthanc
 * Copyright (C) 2023 Sebastien Jodogne, UCLouvain, Belgium
 *
 * This program is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 **/


$('#series').live('pagebeforeshow', function() {
  var seriesId = $.mobile.pageData.uuid;

  $('#volview-button').remove();

  var b = $('<a>')
      .attr('id', 'volview-button')
      .attr('data-role', 'button')
      .attr('href', '#')
      .attr('data-icon', 'search')
      .attr('data-theme', 'e')
      .text("Open Kitware's VolView")
      .button();
  
  b.insertAfter($('#series-info'));
  b.click(function() {
    if ($.mobile.pageData) {
      window.open('../volview/index.html?urls=[../series/' + seriesId + '/archive]');
    }
  });
});


$('#study').live('pagebeforeshow', function() {
  var studyId = $.mobile.pageData.uuid;

  $('#volview-button').remove();

  var b = $('<a>')
      .attr('id', 'volview-button')
      .attr('data-role', 'button')
      .attr('href', '#')
      .attr('data-icon', 'search')
      .attr('data-theme', 'e')
      .text("Open Kitware's VolView")
      .button();
  
  b.insertAfter($('#study-info'));
  b.click(function() {
    if ($.mobile.pageData) {
      window.open('../volview/index.html?urls=[../studies/' + studyId + '/archive]');
    }
  });
});
