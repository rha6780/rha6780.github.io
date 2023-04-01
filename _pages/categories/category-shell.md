---
title: "Shell"
layout: archive
permalink: categories/shell
author_profile: true
sidebar_main: true
---

{% assign posts = site.categories.shell %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}
