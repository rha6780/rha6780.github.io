---
title: "Design Pattern"
layout: archive
permalink: tags/design_pattern
author_profile: true
sidebar_main: true
---

{% assign posts = site.tags.design_pattern %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}

