---
title: "Ruby"
layout: archive
permalink: categories/ruby
author_profile: true
sidebar_main: true
---

{% assign posts = site.categories.ruby %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}
