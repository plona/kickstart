#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
argument obowiązkowy - nazwa pliku z partycjami
prykład:
<?xml version="1.0"?>
<data>
    <free_space>8000</free_space>
    <boot>300</boot>
    <partList>
        <partition name="/root"    min="3000" priority="4000" max="4000" />
        <partition name="/home"    min="1000" priority="1000" max="2000" />
        <partition name="/var/log" min="1500" priority="1800" max="2000" />
        <partition name="swap"     min="1000" priority="1000" max="1000" />
    </partList>
</data>
6. HOW THE ACTUAL PARTITION SIZES ARE COMPUTED
----------------------------------------------

Suppose we have to create N partitions and min[i], max[i] and
priority[i] are the minimal size, the maximal size and the priority of
the partition #i as described in section 1.

Let free_space be the size of the free space to partition.

Then do the following:

for(i=1;i<=N;i++) {
   factor[i] = priority[i] - min[i];
}
ready = FALSE;
while (! ready) {
   minsum = min[1] + min[2] + ... + min[N];
   factsum = factor[1] + factor[2] + ... + factor[N];
   ready = TRUE;
   for(i=1;i<=N;i++) {
      x = min[i] + (free_space - minsum) * factor[i] / factsum;
      if (x > max[i])
         x = max[i];
      if (x != min[i]) {
         ready = FALSE;
         min[i] = x;
      }
   }
}

Then min[i] will be the size of partition #i.
"""
import sys
import xml.etree.ElementTree as ET

maxiter = 999  # max liczba iteracji

root = ET.parse(sys.argv[1]).getroot()

for v in root.findall('free_space'):
    free_space = float(v.text)
for v in root.findall('boot'):
    free_space -= float(v.text)
print free_space

part_list = list()
for part in root.findall('partList'):
    for p in part.findall('partition'):
        part_list.append([
            p.get('name'),
            float(p.get('min')),
            float(p.get('priority')),
            float(p.get('max')),
            float(p.get('priority')) - float(p.get('min'))
        ])
print part_list, len(part_list)

citer = 1
ready = False
while not ready:
    minsum = factsum = 0
    for el in part_list:
        minsum += el[1]
        factsum += el[4]
    if factsum == 0:
        break
    ready = True
    print "\nIteracja:", citer
    print "minsum =", minsum, "factsum = ", factsum
    for i in range(len(part_list)):
        _min = part_list[i][1]
        _max = part_list[i][3]
        factor = part_list[i][4]
        x = round(_min + (free_space - minsum) * factor / factsum, 3)
        if x > _max:
            x = _max
        if x != min:
            ready = False
            part_list[i][1] = x

        print part_list[i][0], ":", part_list[i][1], "\t\tx = ", x

    citer += 1
    if minsum >= free_space or citer > maxiter:
        break

print "\nIteracja:", citer
for el in part_list:
    print el[0], ":", el[1]

