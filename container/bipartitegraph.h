#ifndef BIPARTITEGRAPH_H
#define BIPARTITEGRAPH_H
#include <list>

template <class Type> class Node{
private:
    bool check; // определяет, каким "цветом" окрашена вершина
    Type data;
public:
    Node(Type t);
    Type getData();
};

template <class Type> class PairNode{
private:
    Node<Type> *first, *second;
};

template <class Type> class BipartiteGraph
{
private:
    std::list<Node<Type>> vertixs;
    std::list<PairNode<Type>> pairs;
public:
    BipartiteGraph();
};

#endif // BIPARTITEGRAPH_H
