# CISUC alive

## Required data folder structure

```
├─ data
│  ├─ Events
│  │  ├─ EventA             # Folder name doesn't matter
│  │  │  ├─ info.txt        # This file is required
│  │  │  ├─ images          # A folder with one or more images is optional
│  │  │  │  ├─ img1.jpg
│  │  │  │  └─ img2.jpg
│  │  └─ EventB
│  │     └─ info.txt
│  ├─ News
│  │  └─ ...                 # Same structure as /Events
│  ├─ Pubs_Book_Chapter
│  │  ├─ PubA                # Folder name doesn't matter
│  │  │  ├─ info.txt         # This file is required
│  │  │  └─ foo.pdf          # A PDF file is required
│  │  └─ PubB
│  │     ├─ info.txt
│  │     └─ bar.pdf
│  ├─ Pubs_Conference_Paper
│  │  └─ ...                 # Same structure as /Pubs_Chapter
│  └─ Pubs_Journal_Paper
│     └─ ...                 # Same structure as /Pubs_Chapter
└─ ...
```

## Information file

Each content folder should contain inside a `info.txt` file with specific attributes. 

Find below the attributes which are required or optional for each content category, as well as an example or template.

### Publication

Required and optional attributes:
- `title` (required)
- `authors` (required)
- `year` (required)
- `url` (optional)

Example / template:
```text
#title
Evotype: Evolutionary Type Design

#authors
Tiago Martins, João Correia, Ernesto Costa, Penousal Machado

#year
2015

#url
https://link.springer.com/chapter/10.1007/978-3-319-16498-4_13
```

### News

Required and optional attributes:
- `header` (required)
- `when` (optional)
- `description` (optional)
- `url` (optional)

Example / template:
```text
#header
1st LASI workshop on Smart Cities, Energy, and Mobility

#when
29th May 23

#description
The 1st LASI workshop on Smart Cities, Energy, and Mobility will take place on May 31st, in Room A.6.1 of the Department of Informatics Engineering, at 14h30.

#url
https://www.cisuc.uc.pt/en/1st-lasi-workshop-on-smart-cities-energy-and-mobility
```

### Event

Required and optional attributes:
- `header` (required)
- `when` (required)
- `where` (required)
- `description` (optional)
- `url` (optional)

Example / template:
```text
#header
ALGO talks

#when
12th Mar 21

#where
Zoom room

#description
On 12 March, Pedro Matias, PhD student in Theoretical Computer Science at University of California, Irvine, will give a talk entitled "How to Catch Marathon Cheaters: New Approximation Algorithms for Tracking Paths" in the following zoom link: http://bit.ly/ALGOtalksPedroMatias.

ALGO talks is a seminar series organized by the ALGorithms and Optimization Lab, Adaptive Computation Group, CISUC and University of Coimbra.

#url
https://www.cisuc.uc.pt/en/1st-lasi-workshop-on-smart-cities-energy-and-mobility
```

## Dependencies

The Python script `data_parser.py` requires the following packages installed:

- `pdf2image`
- `Pillow`
