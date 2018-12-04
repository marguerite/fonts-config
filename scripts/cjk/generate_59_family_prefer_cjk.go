package main

import (
	"fmt"
	"log"
	"strconv"
	"strings"
)

func generateMatrix(font, indent string, matrix []float64, langs []string) {
	out := ""

	if len(matrix) != 4 {
		log.Fatalf("Invalid atrix: %v", matrix)
	}

	for _, lang := range langs {
		s := indent + "<match target=\"font\">\n" +
			indent + "  <test name=\"family\">\n" +
			indent + "    <string>" + font + "</string>\n" +
			indent + "  </test>\n" +
			indent + "  <test name=\"namelang\">\n" +
			indent + "    <string>" + lang + "</string>\n" +
			indent + "  </test>\n" +
			indent + "  <edit name=\"matrix\" mode=\"assign\">\n" +
			indent + "    <times>\n" +
			indent + "      <name>matrix</name>\n" +
			indent + "      <matrix>\n" +
			indent + "        <double>" + strconv.FormatFloat(matrix[0], 'f', -1, 64) + "</double>\n" +
			indent + "        <double>" + strconv.FormatFloat(matrix[1], 'f', -1, 64) + "</double>\n" +
			indent + "        <double>" + strconv.FormatFloat(matrix[2], 'f', -1, 64) + "</double>\n" +
			indent + "        <double>" + strconv.FormatFloat(matrix[3], 'f', -1, 64) + "</double>\n" +
			indent + "      </matrix>\n" +
			indent + "    </times>\n" +
			indent + "  </edit>\n" +
			indent + "</match>\n"
		out += s
	}
	fmt.Println(out)
}

func generateWeight(font, indent string, weights [][]int, langs []string) {
	out := ""

	for _, w := range weights {
		if len(w) < 3 {
			log.Fatalf("invalid weight item: %v", w)
		}
	}

	for _, lang := range langs {
		for _, w := range weights {
			s := indent + "<match target=\"font\">\n" +
				indent + "  <test name=\"family\">\n" +
				indent + "    <string>" + font + "</string>\n" +
				indent + "  </test>\n" +
				indent + "  <test name=\"namelang\">\n" +
				indent + "    <string>" + lang + "</string>\n" +
				indent + "  </test>\n"

			if w[0] != 0 {
				s += indent + "  <test name=\"weight\" compare=\"more_eq\">\n" +
					indent + "    <int>" + strconv.FormatInt(int64(w[0]), 10) + "</int>\n" +
					indent + "  </test>\n"
			}

			if w[1] != 0 {
				s += indent + "  <test name=\"weight\" compare=\"less_eq\">\n" +
					indent + "    <int>" + strconv.FormatInt(int64(w[1]), 10) + "</int>\n" +
					indent + "  </test>\n"
			}

			s += indent + "  <edit name=\"weight\" mode=\"assign\">\n" +
				indent + "    <int>" + strconv.FormatInt(int64(w[2]), 10) + "</int>\n" +
				indent + "  </edit>\n" +
				indent + "</match>\n"
			out += s
		}
	}
	fmt.Println(out)
}

func generateWidth(font, indent string, widths []int, langs []string) {
	out := ""

	if len(widths) != 2 {
		log.Fatalf("invalid weight item: %v", widths)
	}

	for _, lang := range langs {
		s := indent + "<match target=\"font\">\n" +
			indent + "  <test name=\"family\">\n" +
			indent + "    <string>" + font + "</string>\n" +
			indent + "  </test>\n" +
			indent + "  <test name=\"namelang\">\n" +
			indent + "    <string>" + lang + "</string>\n" +
			indent + "  </test>\n" +
			indent + "  <test name=\"width\" compare=\"more_eq\">\n" +
			indent + "    <int>" + strconv.FormatInt(int64(widths[0]), 10) + "</int>\n" +
			indent + "  </test>\n" +
			indent + "  <test name=\"width\" compare=\"less_eq\">\n" +
			indent + "    <int>" + strconv.FormatInt(int64(widths[1]), 10) + "</int>\n" +
			indent + "  </test>\n" +
			indent + "  <edit name=\"width\" mode=\"assign\">\n" +
			indent + "    <int>" + strconv.FormatInt(int64(widths[0]), 10) + "</int>\n" +
			indent + "  </edit>\n" +
			indent + "</match>\n"
		out += s
	}
	fmt.Println(out)
}

func generatePrefer(font, indent string, family map[string][]string, lang_specific map[string]Lang_specific, langs []string) {
	out := ""
	lang_map := map[string]string{
		"zh-cn": "cn", "zh-sg": "cn",
		"zh-tw": "tw", "zh-hk": "tw", "zh-mo": "tw",
		"ja": "jp", "ko": "kr"}

	for _, lang := range langs {
		edit_lang := lang_map[lang]
		s := indent + "<match>\n" +
			indent + "  <test name=\"family\">\n" +
			indent + "    <string>" + font + "</string>\n" +
			indent + "  </test>\n" +
			indent + "  <test name=\"lang\">\n" +
			indent + "    <string>" + lang + "</string>\n" +
			indent + "  </test>\n" +
			indent + "  <edit name=\"family\" mode=\"prepend\">\n"

		for m, n := range lang_specific {
			if m == edit_lang && len(n.Prefer) > 0 {
				for x, y := range n.Prefer {
					if x == font {
						for _, k := range y {
							s += indent + "    <string>" + k + "</string>\n"
						}
					}
				}
			}
		}

		if font == "sans-serif" {
			s += indent + "    <string>Noto Sans</string>\n"
		}

		s += indent + "    <string>" + family[edit_lang][0] + "</string>\n"

		if font != "monospace" {
			for i, v := range family {
				if i != edit_lang {
					s += indent + "    <string>" + v[0] + "</string>\n"
				}
			}

			s += indent + "    <string>" + family[edit_lang][1] + "</string>\n"
		}

		for m, n := range lang_specific {
			if m == edit_lang && len(n.Append) > 0 {
				for x, y := range n.Append {
					if x == font {
						for _, k := range y {
							s += indent + "    <string>" + k + "</string>\n"
						}
					}
				}
			}
		}

		s += indent + "  </edit>\n" +
			indent + "</match>\n"
		out += s

	}
	fmt.Println(out)
}

func buildSourceHanFontsList() []string {
	var fonts []string
	family := []string{" Sans", " Serif", " Sans HW"}
	variants := []string{" CN", " TW", " JP", " KR", "", " J", " K", " SC", " TC"}

	for _, f := range family {
		for _, v := range variants {
			font := "Source Han" + f + v
			fonts = append(fonts, font)
		}
	}
	return fonts
}

func suffixContain(s string, suffix []string) bool {
	b := false
	for _, v := range suffix {
		if s == v {
			return true
		}
	}
	return b
}

func remainFamily(family map[string][]string, lang string) []string {
	var remains []string
	for i, v := range family {
		if i != lang {
			remains = append(remains, v[0])
		}
	}
	return remains
}

func generateSourceHanAlias(fonts []string, indent string, sans, serif, mono map[string][]string) {
	out := ""
	region_suffix := []string{"CN", "TW", "JP", "KR"}
	otc_suffix := []string{"J", "K", "SC", "TC"}
	lang_map := map[string]string{"CN": "cn", "SC": "cn", "TW": "tw", "TC": "tw",
		"JP": "jp", "J": "jp", "KR": "kr", "K": "kr"}

	for _, f := range fonts {
		fa := strings.Split(f, " ")
		if suffixContain(fa[len(fa)-1], []string{"Sans", "Serif", "HW"}) {
			fa = append(fa, "J")
		}
		lang := fa[len(fa)-1]
		variant := fa[len(fa)-2]
		edit_lang := lang_map[lang]
		family_map := map[string]string{"Sans": sans[edit_lang][0],
			"Serif": serif[edit_lang][0],
			"HW":    mono[edit_lang][0]}
		remain_map := map[string][]string{"Sans": remainFamily(sans, edit_lang),
			"Serif": remainFamily(serif, edit_lang),
			"HW":    make([]string, 0)}
		str := indent + "<alias>\n" + indent + "  <family>" + f + "</family>\n"

		if suffixContain(lang, region_suffix) {
			if variant == "Sans" {
				str += indent + "  <prefer>\n" +
					indent + "    <family>Noto Sans</family>\n" +
					indent + "  </prefer>\n"
			}
			str += indent + "  <accept>\n" +
				indent + "    <family>" + family_map[variant] + "</family>\n" +
				indent + "  </accept>\n"
		}

		if suffixContain(lang, otc_suffix) {
			if variant == "HW" {
				str += indent + "  <accept>\n"
			} else {
				str += indent + "  <prefer>\n"
			}
			if variant == "Sans" {
				str += indent + "    <family>Noto Sans</family>\n"
			}
			str += indent + "    <family>" + family_map[variant] + "</family>\n"
			for _, r := range remain_map[variant] {
				str += indent + "    <family>" + r + "</family>\n"
			}
			if variant == "HW" {
				str += indent + "  </accept>\n"
			} else {
				str += indent + "  </prefer>\n"
			}
		}
		out += str + indent + "</alias>\n"
	}
	fmt.Println(out)
}

func buildNotoCJKAndSourceHanList(sans, serif, mono map[string][]string) []string {
	fonts := buildSourceHanFontsList()
	for _, l := range []map[string][]string{sans, serif, mono} {
		for _, v := range l {
			for _, k := range v {
				fonts = append(fonts, k)
			}
		}
	}
	return fonts
}

func generateHinting(fonts []string, indent, hint string) {
	out := ""
	for _, v := range fonts {
		s := indent + "<match target=\"font\">\n" +
			indent + "  <test name=\"family\">\n" +
			indent + "    <string>" + v + "</string>\n" +
			indent + "  </test>\n" +
			indent + "  <edit name=\"hintstyle\" mode=\"assign\">\n" +
			indent + "    <const>" + hint + "</const>\n" +
			indent + "  </edit>\n" +
			indent + "</match>\n"
		out += s
	}
	fmt.Println(out)
}

type Lang_specific struct {
	Prefer map[string][]string
	Append map[string][]string
}

func main() {
	langs := []string{"zh-cn", "zh-sg", "zh-tw", "zh-hk", "zh-mo", "ja", "ko"}
	namelangs := []string{"zh-CN", "zh-SG", "zh-TW", "zh-HK", "zh-MO", "ja", "ko"}
	matrix := []float64{0.67, 0, 0, 0.67}
	weights := [][]int{{0, 40, 0}, {50, 99, 50}, {99, 179, 80}, {180, 0, 180}}
	widths := []int{63, 100}
	sans := map[string][]string{
		"cn": {"Noto Sans SC", "Noto Sans CJK SC"},
		"tw": {"Noto Sans TC", "Noto Sans CJK TC"},
		"jp": {"Noto Sans JP", "Noto Sans CJK JP"},
		"kr": {"Noto Sans KR", "Noto Sans CJK KR"},
	}
	serif := map[string][]string{
		"cn": {"Noto Serif SC", "Noto Serif CJK SC"},
		"tw": {"Noto Serif TC", "Noto Serif CJK TC"},
		"jp": {"Noto Serif JP", "Noto Serif CJK JP"},
		"kr": {"Noto Serif KR", "Noto Serif CJK KR"},
	}
	mono := map[string][]string{
		"cn": {"Noto Sans Mono CJK SC"},
		"tw": {"Noto Sans Mono CJK TC"},
		"jp": {"Noto Sans Mono CJK JP"},
		"kr": {"Noto Sans Mono CJK KR"},
	}
	lang_specific := map[string]Lang_specific{
		"tw": {Append: map[string][]string{"serif": {"CMEXSong"}}},
		"kr": {Append: map[string][]string{"sans-serif": {"NanumGothic"}, "serif": {"NanumMyeongjo"}, "monospace": {"NanumGothicCoding"}}},
		"jp": {Prefer: map[string][]string{"sans-serif": {"IPAPGothic", "IPAexGothic", "M+ 1c", "M+ 1p", "VL PGothic"}, "serif": {"IPAPMincho", "IPAexMincho"}, "monospace": {"IPAGothic", "M+ 1m", "VL Gothic"}}, Append: map[string][]string{"sans-serif": {"IPAGothic"}, "serif": {"IPAMincho"}}},
	}

	indent := strings.Repeat(" ", 2)
	list := buildNotoCJKAndSourceHanList(sans, serif, mono)

	fmt.Println("<?xml version=\"1.0\"?>")
	fmt.Println("<!DOCTYPE fontconfig SYSTEM \"fonts.dtd\">")
	fmt.Println("<fontconfig>")
	generateMatrix("Noto Sans", indent, matrix, namelangs)
	generateWeight("Noto Sans", indent, weights, namelangs)
	generateWidth("Noto Sans", indent, widths, namelangs)
	generatePrefer("sans-serif", indent, sans, lang_specific, langs)
	generatePrefer("serif", indent, serif, lang_specific, langs)
	generatePrefer("monospace", indent, mono, lang_specific, langs)
	generateSourceHanAlias(buildSourceHanFontsList(), indent, sans, serif, mono)
	generateHinting(list, indent, "hintfull")
	fmt.Println("</fontconfig>")
}
