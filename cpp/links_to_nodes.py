#!/usr/bin/env python
# encoding: utf-8

"""
This is a script intended to translate clusters of links (edges) to clusters of
nodes. Specifically, it takes a file of clusters, one per line, where each
cluster (line) is a list of edge pairs separated by spaces. Each edge pair
consists of the two endpoint node IDs, separated by a comma. The output file
contains the same clusters, but broken down into nodes instead of edges. This is
done by extracting the node IDs from all edges for a cluster and putting them
into a set, then writing that set of unique node IDs to the line in the output
file to represent the cluster.

"""
import os
import sys


def convert_to_nodes(link_clusters_file, outfile=''):
    # If no output file is given; modify input filename to produce one.
    if not outfile:
        outfile = convert_path(link_clusters_file)

    with open(link_clusters_file) as f:
        lines = (line.strip() for line in f)

        # The clusters consist of a string of links; split into a list.
        link_clusters = (line.split() for line in lines)

        # Now split the links into nodes; we have a list of lists.
        nested_nodes = (map(lambda link: link.split(','), link_cluster)
                       for link_cluster in link_clusters)

        # Reduce the nested lists to 1-D: elements are nodes.
        node_lists = (reduce(lambda x,y: x+y, node_lists)
                     for node_lists in nested_nodes)

        # Remove duplicate nodes from clusters, and we're done.
        node_clusters = (set(node_list) for node_list in node_lists)

        # Finally, write the new clusters to the output file.
        with open(outfile, 'w') as out:
            for cluster in node_clusters:
                out.write('%s\n' % ' '.join(cluster))


def convert_path(path):
    """Convert input file path to a suitable output file name."""
    if '-link-' in path:  # case for standard output naming
        return path.replace('-link-', '-node-')
    else:
        base, ext = os.path.splitext(path)
        outfile = '%s-by-node%s' % (base, ext)


if __name__ == "__main__":
    usage = "%s <link-cluster-file> [<output-file>]" % sys.argv[0]
    if len(sys.argv) < 2:
        print usage
        sys.exit(1)
    elif len(sys.argv) > 2:
        arg = sys.argv[2]
        if arg.startswith('-'):
            if arg == '-h' or arg == '--help':
                print usage
                sys.exit(0)
            else:
                print 'unkown flag: %s' % arg
                sys.exit(3)

    outfile = sys.argv[2] if len(sys.argv) > 2 else ''

    try:
        convert_to_nodes(sys.argv[1], outfile)
    except IOError:
        print "Unable to open input file: %s" % sys.argv[1]
        sys.exit(2)
