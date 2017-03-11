#include "bipartitegraph.h"

/* !!! BipartiteGraph !!! */
template <class Type> BipartiteGraph<Type>::BipartiteGraph(){
}
/* !!! BipartiteGraph END !!! */

/* !!! Node !!! */
template <class Type> Node<Type>::Node() {

}

template <class Type> Node<Type>::Node(Type d) {
    data = d;
}

template <class Type> Node<Type>::Node(Type d, bool c) {
    data = d;
    check = c;
}

template <class Type> Type Node<Type>::getData() {
    return data;
}

template <class Type> void Node<Type>::setData(Type d) {
    data = d;
}

template <class Type> bool Node<Type>::isCheck() {
    return check;
}

template <class Type> void Node<Type>::setCheck(bool c){
    check = c;
}
/* !!! Node END !!! */

/* !!! PairNode !!! */
template <class Type> PairNode<Type>::PairNode(){

}

template <class Type> PairNode<Type>::PairNode(Node<Type> f,Node<Type> s){
    first = &f;
    second = &s;
}

template <class Type> Node<Type> PairNode<Type>::getFisrt() {
    return *first;
}

template <class Type> void PairNode<Type>::setFisrt(Node<Type> f) {
    first = &f;
}

template <class Type> Node<Type> PairNode<Type>::getSecond() {
    return *second;
}

template <class Type> void PairNode<Type>::setSecond(Node<Type> s) {
    second = s;
}
/* !!! PairNode END !!! */
