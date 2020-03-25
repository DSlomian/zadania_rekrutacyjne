from collections import Counter

def podziel(text):
    return "".join(text.split()).lower()
print("Proszę podać tekst w którym mam znaleźć największą liczbę powtarzających się liter")
text = input()
dictionary = Counter(podziel(text))
list_of_numbers=Counter(dictionary).most_common()
max_number=Counter(dictionary).most_common(1)
print("Powtarzające się litera/y to:",set(x for x, count in list_of_numbers if count == list_of_numbers[0][1]),"o liczbie",max_number[0][1])
