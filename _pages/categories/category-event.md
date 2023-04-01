---
title: "event"
layout: archive
permalink: categories/event
author_profile: true
sidebar_main: true
---

{% assign posts = site.categories.event %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}
