# ==========================================================================
# Neighborhood Typology
# By: Tim Thomas - timothyathomas@gmail.com
# Measures drawn from:
# 	Hall, Matthew, Kyle Crowder, and Amy Spring. 2015. “Neighborhood
# 		Foreclosures, Racial/Ethnic Transitions, and Residential
# 		Segregation.” American Sociological Review 80:526–549.
#
# Process:
# 	1. Create a dataframe with the proportions for White, Black, Asian,
# 		Latinx, and Other.
# 	2. Run the `nt` function on that dataset to create a `NeighType` field
# 	3. Look at your neighborhood typology frequency and consider merging
# 		similar, or low frequency, neighborhoods into one or more common
# 		categories (e.g., some of the four category cases could be considered
# 		white-mixed--see the article to see how the authors consolidated
# 		categories).
# ==========================================================================

# ==========================================================================
# NT Formula
# ==========================================================================

nt <- function(df, GEOID = "GEOID", totraceE = "toteraceE", pWhite = "pWhite", pBlack = "pBlack", pAsian = "pAsian", pLatinx = "pLatinx", pOther = "pOther", NeighType = "NeighType", nt_conc = "nt_conc"){
	df %>%
	dplyr::group_by(GEOID) %>%
	dplyr::mutate(NeighType =
		dplyr::case_when(
			pWhite >=.9 ~ "All White",
			pBlack >=.9 ~ "All Black",
			pAsian >=.9 ~ "All Asian",
			pLatinx >=.9 ~ "All Latinx",
			pOther >=.9 ~ "All Other",
			pWhite < .9 & pBlack < .1 & pAsian < .1 & pLatinx < .1 & pOther < .1 ~ "White-Shared",
			pBlack < .9 & pWhite < .1 & pAsian < .1 & pLatinx < .1 & pOther < .1 ~ "Black-Shared",
			pAsian < .9 & pBlack < .1 & pWhite < .1 & pLatinx < .1 & pOther < .1 ~ "Asian-Shared",
			pLatinx < .9 & pBlack < .1 & pAsian < .1 & pWhite < .1 & pOther < .1 ~ "Latinx-Shared",
			pOther < .9 & pBlack < .1 & pAsian < .1 & pLatinx < .1 & pWhite < .1 ~ "Other-Shared",
			pWhite >=.1 & pWhite < .9 & pBlack >=.1 & pBlack < .9 & pAsian < .1 & pLatinx < .1 & pOther < .1 ~ "Black-White",
			pWhite >=.1 & pWhite < .9 & pLatinx >=.1 & pLatinx < .9 & pAsian < .1 & pBlack < .1 & pOther < .1 ~ "Latinx-White",
			pWhite >=.1 & pWhite < .9 & pAsian >=.1 & pAsian < .9 & pBlack < .1 & pLatinx < .1 & pOther < .1 ~ "Asian-White",
			pWhite >= .1 & pWhite < .9 & pOther >=.1 & pOther < .9 & pBlack < .1 & pLatinx < .1 & pAsian < .1 ~ "Other-White",
			pBlack >=.1 & pBlack < .9 & pOther >=.1 & pOther < .9 & pWhite < .1 & pLatinx < .1 & pAsian < .1 ~ "Black-Other",
			pBlack >=.1 & pBlack < .9 & pLatinx >=.1 & pLatinx < .9 & pWhite < .1 & pAsian < .1 & pOther < .1 ~ "Black-Latinx",
			pAsian >=.1 & pAsian < .9 & pBlack >=.1 & pBlack < .9 & pWhite < .1 & pLatinx < .1 & pOther < .1 ~ "Asian-Black",
			pAsian >=.1 & pAsian < .9 & pLatinx >=.1 & pLatinx < .9 & pWhite < .1 & pBlack < .1 & pOther < .1 ~ "Asian-Latinx",
			pAsian >= .1 & pAsian < .9 & pOther >=.1 & pOther < .9 & pWhite < .1 & pLatinx < .1 & pBlack < .1 ~ "Asian-Other",
			pLatinx >= .1 & pLatinx < .9 & pOther >=.1 & pOther < .9 & pWhite < .1 & pAsian < .1 & pBlack < .1 ~ "Latinx-Other",
			pBlack >=.1 & pAsian >=.1 & pLatinx >=.1 & pWhite < .1 & pOther < .1 ~ "Black-Asian-Latinx",
			pBlack >=.1 & pAsian >=.1 & pOther >=.1 & pWhite < .1 & pLatinx < .1 ~ "Black-Asian-Other",
			pBlack >=.1 & pLatinx >=.1 & pOther >=.1 & pWhite < .1 & pAsian < .1 ~ "Black-Latinx-Other",
			pAsian >=.1 & pLatinx >=.1 & pOther >=.1 & pWhite < .1 & pBlack < .1 ~ "Asian-Latinx-Other",
			pWhite >=.1 & pBlack >=.1 & pAsian >=.1 & pLatinx < .1 & pOther < .1 ~ "Black-Asian-White",
			pWhite >=.1 & pBlack >=.1 & pLatinx >=.1 & pAsian < .1 & pOther < .1 ~ "Black-Latinx-White",
			pWhite >=.1 & pBlack >=.1 & pOther >=.1 & pLatinx < .1 & pAsian < .1 ~ "Black-Other-White",
			pWhite >=.1 & pAsian >=.1 & pLatinx >=.1 & pBlack < .1 & pOther < .1 ~ "Asian-Latinx-White",
			pWhite >=.1 & pAsian >=.1 & pOther >=.1 & pLatinx < .1 & pBlack < .1 ~ "Asian-Other-White",
			pWhite >=.1 & pLatinx >=.1 & pOther >=.1 & pAsian < .1 & pBlack < .1 ~ "Latinx-Other-White",
			pWhite >=.1 & pLatinx >=.1 & pOther >=.1 & pAsian < .1 & pBlack < .1 ~ "Latinx-Other-White",
			pBlack >=.1 & pAsian >=.1 & pLatinx >=.1 & pOther >=.1 & pWhite < .1 ~ "Black-Asian-Latinx-Other",
			pWhite >=.1 & pAsian >=.1 & pLatinx >=.1 & pOther >=.1 & pBlack < .1 ~ "Asian-Latinx-Other-White",
			pWhite >=.1 & pBlack >=.1 & pLatinx >=.1 & pOther >=.1 & pAsian < .1 ~ "Black-Latinx-Other-White",
			pWhite >=.1 & pBlack >=.1 & pAsian >=.1 & pOther >=.1 & pLatinx < .1 ~ "Black-Asian-Other-White",
			pWhite >=.1 & pBlack >=.1 & pAsian >=.1 & pLatinx >=.1 & pOther < .1 ~ "Black-Asian-Latinx-White",
			pWhite >=.1 & pWhite <=.7 & pBlack >=.1 & pAsian >=.1 & pLatinx >=.1 & pOther >=.1 ~ "Diverse",
			totraceE == 0 ~ "Unpopulated Tract"
			)
	) %>%
	dplyr::ungroup() %>%
	dplyr::mutate(nt_conc =
		dplyr::case_when(
			NeighType == "Black-Asian-Latinx-Other" ~ "4 Group Mixed",
			NeighType == "Asian-Latinx-Other-White" ~ "4 Group Mixed",
			NeighType == "Black-Latinx-Other-White" ~ "4 Group Mixed",
			NeighType == "Black-Asian-Other-White" ~ "4 Group Mixed",
			NeighType == "Black-Asian-Latinx-White" ~ "4 Group Mixed",
			NeighType == "Black-Asian-Latinx" ~ "3 Group Mixed",
			NeighType == "Black-Asian-Other" ~ "3 Group Mixed",
			NeighType == "Black-Latinx-Other" ~ "3 Group Mixed",
			NeighType == "Asian-Latinx-Other" ~ "3 Group Mixed",
			NeighType == "Black-Asian-White" ~ "3 Group Mixed",
			NeighType == "Black-Latinx-White" ~ "3 Group Mixed",
			NeighType == "Black-Other-White" ~ "3 Group Mixed",
			NeighType == "Asian-Latinx-White" ~ "3 Group Mixed",
			NeighType == "Asian-Other-White" ~ "3 Group Mixed",
			NeighType == "Latinx-Other-White" ~ "3 Group Mixed",
			NeighType == "Latinx-Other-White" ~ "3 Group Mixed",
			NeighType == "All White" ~ "Mostly White",
			NeighType == "All Black" ~ "Mostly Black",
			NeighType == "All Asian" ~ "Mostly Asian",
			NeighType == "All Latinx" ~ "Mostly Latinx",
			NeighType == "All Other" ~ "Mostly Other",
			NeighType == "White-Shared" ~ "Mostly White",
			NeighType == "Black-Shared" ~ "Mostly Black",
			NeighType == "Asian-Shared" ~ "Mostly Asian",
			NeighType == "Latinx-Shared" ~ "Mostly Latinx",
			NeighType == "Other-Shared" ~ "Mostly Other",
			TRUE ~ NeighType
		)
	) %>%
	dplyr::mutate(nt_conc =
		factor(nt_conc,
			levels = c(
				"Mostly Asian",
				"Mostly Black",
				"Mostly Latinx",
				"Mostly Other",
				"Mostly White",

				"Asian-Black",
				"Asian-Latinx",
				"Asian-Other",
				"Asian-White",

				"Black-Latinx",
				"Black-Other",
				"Black-White",

				"Latinx-Other",
				"Latinx-White",

				"Other-White",
				"3 Group Mixed",
				"4 Group Mixed",
				"Diverse",
				"Unpopulated Tract"
				)
		)
	)
}

# ==========================================================================
# Create data frame
# ==========================================================================

ntdf <- function(
	state,
	geography = "tract",
	county = NULL,
	geometry = FALSE,
	cache_table = TRUE,
	output = "wide",
	year = NULL,
	GEOID = "GEOID",
	WhiteE = "WhiteE",
	AsianE = "AsianE",
	BlackE = "BlackE",
	LatinxE = "LatinxE",
	totraceE = "totraceE"
){

race_vars <-
	c('totrace' = 'B03002_001',
	  'White' = 'B03002_003',
	  'Black' = 'B03002_004',
	  'Asian' = 'B03002_006',
	  'Latinx' = 'B03002_012')

acs_data <-
	tidycensus::get_acs(
		geography = geography,
		variables = race_vars,
		state = state,
		county = county,
		geometry = geometry,
		cache_table = cache_table,
		output = output,
		year = year,
		cb = TRUE
		) %>%
	dplyr::select(-dplyr::ends_with("M")) %>%
	dplyr::group_by(GEOID) %>%
	dplyr::mutate(pWhite = WhiteE/totraceE,
		   pAsian = AsianE/totraceE,
		   pBlack = BlackE/totraceE,
		   pLatinx = LatinxE/totraceE,
		   pOther = (totraceE - sum(WhiteE, AsianE, BlackE, LatinxE, na.rm = TRUE))/totraceE)

 nt(df = acs_data)

}

# ==========================================================================
# Check nt categories
# ==========================================================================

ntcheck <- function(df, NeighType = "NeighType", n = "n")
	df %>% dplyr::group_by(NeighType) %>% dplyr::count() %>% dplyr::arrange(dplyr::desc(n)) %>% data.frame()

###
# Suggest Pal
###
# nt_pal <-
#     colorFactor(c(
#         '#33a02c', # 'Mostly Asian', green
#         '#1f78b4', # 'Mostly Black', blue
#         '#e31a1c', # 'Mostly Latinx', red
#         '#9b66b0', # 'Mostly Other', purple
#         '#C95123', # 'Mostly White',
#         '#1fc2ba', # 'Asian-Black',
#         '#d6ae5c', # 'Asian-Latinx',
#         '#91c7b9', # 'Asian-Other',
#         '#b2df8a', # 'Asian-White',
#         '#de4e4b', # 'Black-Latinx',
#         '#71a1f5', # 'Black-Other',
#         '#a6cee3', # 'Black-White',
#         '#f0739b', # 'Latinx-Other',
#         '#fb9a99', # 'Latinx-White',
#         '#c28a86', # 'Other-White',
#         '#fdbf6f', # '3 Group Mixed',
#         '#cab2d6', # '4 Group Mixed',
#         '#1d5fd1', # 'Diverse',
#         '#FFFFFF'),  # 'Unpopulated Tract'
#       domain = df$nt_conc,
#       na.color = '#C0C0C0'
#         )