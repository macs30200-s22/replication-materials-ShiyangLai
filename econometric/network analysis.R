magic_fun <- function(x){
  return (x*100)}

par(mfrow=c(1,3), mar=c(2,2,2,2))


df <- data.frame(lapply(dy12$tables[3], magic_fun))
# print(df, digits=4)

# load graph
g <- graph.adjacency(as.matrix(df), mode="directed", weighted=TRUE) # For directed 
g <- simplify(g, remove.loops = TRUE)

# determine the width and the color of edges
E(g)$width <- log((E(g)$weight + 1) * 1.5)
color_map <- vector(mode='numeric')
for (i in c(1:length(ends(g, es=E(g), names=T)[,1]))) {
  if (is.element(ends(g, es=E(g), names=T)[i,1], focals[crypto]) && is.element(ends(g, es=E(g), names=T)[i,2], focals[conven])) {
    color_map <- append(color_map, '#6C3483')
  } else {
    if (is.element(ends(g, es=E(g), names=T)[i,1], focals[conven]) && is.element(ends(g, es=E(g), names=T)[i,2], focals[crypto])) {
      color_map <- append(color_map, '#6C3483')
    } else {
      color_map <- append(color_map, '#1C2833')
    }
  }
}
E(g)$edge.color <- color_map

# determine the color of nodes. The opacity reflects the within-market pagerank
# V(g)$color <- ifelse(is.element(V(g)$name, focals[crypto]), 'darkred', 'darkblue')
g_c.in <- g
g_c.in <- delete.edges(g_c.in, which(E(g_c.in)$edge.color=='#6C3483'))
pagerank <- (page_rank(g_c.in)$vector-min(page_rank(g_c.in)$vector)+0.05)/(max(page_rank(g_c.in)$vector)-min(page_rank(g_c.in)$vector)+0.05)
color_map <- vector(mode='numeric')
for (i in focals) {
  if (is.element(i, focals[crypto])) {
    color_map[i] <- adjustcolor('darkred', alpha.f=pagerank[i])
  } else {
    color_map[i] <- adjustcolor('darkblue', alpha.f=pagerank[i])
  }
  
}
V(g)$color <- color_map

# determine the size of nodes. The size reflects cross-market pagerank 
g_c.out <- g
g_c.out <- delete.edges(g_c.out, which(E(g_c.out)$edge.color=='#1C2833'))
V(g)$size <- page_rank(g_c.out)$vector*230

# draw the plot
g %>% add_layout_(in_circle()) %>%
  plot(edge.arrow.size=0.2, vertex.color=V(g)$color,
     edge.color = adjustcolor(E(g)$edge.color, .5), vertex.label = V(g)$name,
     vertex.label.color='black', vertex.label.cex=1.1, 
     edge.curved=0.2, shape='circle', vertex.arrow.size=30, vertex.size=V(g)$size,
     vertex.label.dist=3.5, vertex.label.degree = -pi/2)
title("Connectedness within 100 days",cex.main=1.7,family="Times", line = -34.2)


# analysis
keyplayer(g, k=10)
