import urllib.request

claveToDepto={
 'ACT': 'ACTUARIA Y SEGUROS',
 'ADM': 'ADMINISTRACION',
 'CSO': 'CIENCIA POLITICA',
 'COM': 'COMPUTACION',
 'CON': 'CONTABILIDAD',
 'CEB': 'CTRO DE ESTUDIO DEL BIENESTAR',
 'DER': 'DERECHO',
 'ECO': 'ECONOMIA',
 'EST': 'ESTADISTICA',
 'EGN': 'ESTUDIOS GENERALES',
 'EIN': 'ESTUDIOS INTERNACIONALES',
 'IIO': 'ING. INDUSTRIAL Y OPERACIONES',
 'CLE': 'LENGUAS (CLE)',
 'LEN': 'LENGUAS (LEN)',
 'MAT': 'MATEMATICAS',
 'SDI': 'SISTEMAS DIGITALES'
 }

deptoToColor={
 'ACT': 4293943954,
 'ADM': 4293874512,
 'CSO': 4294930499,
 'COM': 4281944491,
 'CON': 4280723098,
 'DER': 4278426597,
 'ECO': 4294938368,
 'EST': 'ESTADISTICA',
 'EGN': 'ESTUDIOS GENERALES',
 'EIN': 'ESTUDIOS INTERNACIONALES',
 'IIO': 4281944491,
 'CLE': 'LENGUAS (CLE)',
 'LEN': 'LENGUAS (LEN)',
 'MAT': 'MATEMATICAS',
 'SDI': 'SISTEMAS DIGITALES',
 'CEB': 'CTRO DE ESTUDIO DEL BIENESTAR'
 }

def getHTML(url):
    """
    Regresa el contenido HTML del url.
    """
    with urllib.request.urlopen(url) as u:
        html=u.read().decode("utf-8","ignore")
    return html

def replace_latin_chars(str):
    """
    Reemplaza letras con acentos por letras sin acentos y ñ con n en str.
    """
    translate = {"Á": "A", "É": "E", "Í": "I", "Ó": "O", "Ú": "U", "Ñ": "N", "Ü": "U","á": "a", "é": "e", "í": "i", "ó": "o", "ú": "u", "ñ": "n", "ü": "u"}
    for original,replacement in translate.items():
        str.replace(original,replacement)
    return str

def levenshtein(s0, s1):
    """
    Calculates the levenshtein distance.
    Taken from https://github.com/luozhouyang/python-string-similarity/blob/master/strsimpy/levenshtein.py
    """
    if s0 == s1:
        return 0.0
    if len(s0) == 0:
        return len(s1)
    if len(s1) == 0:
        return len(s0)

    v0 = [0] * (len(s1) + 1)
    v1 = [0] * (len(s1) + 1)

    for i in range(len(v0)):
        v0[i] = i

    for i in range(len(s0)):
        v1[0] = i + 1
        for j in range(len(s1)):
            cost = 1
            if s0[i] == s1[j]:
                cost = 0
            v1[j + 1] = min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
        v0, v1 = v1, v0

    return v0[len(s1)]

def levenshtein_ratio(a,b):
    a=a.lower().strip()
    b=b.lower().strip()
    edits_away=0
    for index,letter in enumerate(a):
        try:
            if letter!=b[index]:edits_away+=1
        except:edits_away+=1
    ratio=((len(a)+len(b)) - edits_away) / (len(a)+len(b))
    return ratio

def levenshteinSimilarity(s0,s1):
    """
    Returns the normalized levenshtein similarity
    """
    m=max(len(s0),len(s1))
    if m==0:
        return 1.0
    return 1-(levenshtein(s0,s1)/m)
