/* ΔOS: Decentralized Operating System

Copyright (c) 2013-2017 Andrew DeSantis <atd@gmx.it>
Copyright (c) 2016-2017 DeSantis Inc. <inc@gmx.it>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

This file incorporates work covered by the BSD 2-Clause License,
as well as the following copyright, and permission notice:
---
ΔOS may be used and distributed under the terms of the GPLv3,
which are available at: <http://www.gnu.org/licenses/gpl-3.0.html>

If you would like to embed ΔOS within a commercial application or
redistribute it in a modified binary form, contact DeSantis Inc.
*/

#ifndef __DELIST__
#define __DELIST__

#ifdef __cplusplus
extern "C" {
#endif

#ifndef __ATDLIB__
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif

#include "deListNode.h"

typedef struct deListObject
{   int size;
	deListNode *sentinel;
} deList;

extern deList *newList(void);
extern void freeList(deList *list);
extern int appendList(deList *ptr, int value);
extern void deleteList(deList *lst, deListNode *n);
extern void graphList(deList *list, FILE *fp);
extern int prependList(deList *ptr, int value);
extern int searchList(deList *ptr, int value);
extern int getListSize(deList *ptr);
extern deListNode *getListHead(deList *ptr);
extern deListNode *getListTail(deList *ptr);
extern deListNode *getListSentinel(deList *ptr);

#ifdef __cplusplus
}
#endif

#endif /* __DELIST__ */