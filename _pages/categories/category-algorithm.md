---
title: "Algorithm"
layout: archive
permalink: categories/algorithm
author_profile: true
sidebar_main: true
---

{% if paginator %}
  {% assign posts = paginator.posts %}
{% else %}
  {% assign posts = site.categories.algorithm %}
{% endif %}

{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %} 
{% endfor %}

